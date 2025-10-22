# ==========================================
# sp_menu_comentado_v2.py
# CRUD básico con Procedimientos Almacenados (MySQL) desde Python
# Autor: Dany (con expansiones)
# Propósito: Permitir insertar, listar, actualizar, eliminar lógicamente,
# restaurar y eliminar físicamente empleados usando SPs.
# ==========================================

# Importa el conector oficial de MySQL para Python
import mysql.connector

# ---------- CONFIGURACIÓN DE CONEXIÓN ----------
# Diccionario con los parámetros necesarios para establecer la conexión con la BD.
DB_CONFIG = {
    "host": "localhost",        # Servidor donde corre MySQL (local en este caso)
    "user": "root",             # Usuario con permisos de acceso
    "password": "1234",   # Reemplaza con la contraseña real o déjalo vacío si no tiene
    "database": "empresa"       # Nombre de la base de datos a utilizar
    # "port": 3306,             # (Opcional) solo si tu MySQL usa un puerto distinto
}

# ---------- FUNCIÓN DE CONEXIÓN ----------
def conectar():
    """
    Crea y devuelve una conexión a MySQL usando los parámetros definidos en DB_CONFIG.
    Si la conexión falla, lanzará una excepción de tipo mysql.connector.Error.
    """
    return mysql.connector.connect(**DB_CONFIG)

# ---------- FUNCIONES PRINCIPALES (Originales) ----------
def sp_insertar(nombre: str, cargo: str, sueldo: float) -> int:
    """
    Inserta un nuevo empleado llamando al procedimiento almacenado:
    sp_insertar_empleado(IN p_nombre, IN p_cargo, IN p_sueldo, OUT p_nuevo_id)
    Devuelve el ID generado por la inserción, o -1 si ocurre un error.
    """
    cnx = cur = None
    try:
        cnx = conectar()
        cur = cnx.cursor()
        args = [nombre, cargo, sueldo, 0]  # Prepara los argumentos, el último es OUT
        args = cur.callproc("sp_insertar_empleado", args)  # Llama al procedimiento almacenado
        cnx.commit()
        nuevo_id = args[3]      # Recupera el valor OUT (el nuevo ID generado)
        print(f"✅ Insertado correctamente. Nuevo ID: {nuevo_id}")
        return nuevo_id
    except mysql.connector.Error as e:
        print("❌ Error en sp_insertar:", e)
        if cnx and cnx.is_connected():
            try: cnx.rollback()
            except: pass
        return -1
    finally:
        if cur: cur.close()
        if cnx and cnx.is_connected(): cnx.close()

def sp_listar_activos():
    """
    Llama al procedimiento almacenado sp_listar_empleados_activos().
    Muestra en consola todos los registros activos (eliminado = 0).
    """
    cnx = cur = None
    try:
        cnx = conectar()
        cur = cnx.cursor()
        cur.callproc("sp_listar_empleados_activos")
        print("\n=== EMPLEADOS ACTIVOS ===")
        count = 0
        for result in cur.stored_results():
            for (id_, nombre, cargo, sueldo, created_at, updated_at) in result.fetchall():
                count += 1
                ua = updated_at if updated_at is not None else "-"
                print(f"ID:{id_:<3} | Nombre:{nombre:<15} | Cargo:{cargo:<13} | "
                      f"Sueldo:${sueldo:,.0f} | Creado:{created_at} | Actualizado:{ua}")
        if count == 0:
            print("No se encontraron empleados activos.")
    except mysql.connector.Error as e:
        print("❌ Error en sp_listar_activos:", e)
    finally:
        if cur: cur.close()
        if cnx and cnx.is_connected(): cnx.close()

def sp_listar_todos():
    """
    Llama al procedimiento almacenado sp_listar_empleados_todos()
    Muestra en consola todos los registros, tanto activos como eliminados.
    """
    cnx = cur = None
    try:
        cnx = conectar()
        cur = cnx.cursor()
        cur.callproc("sp_listar_empleados_todos")
        print("\n=== EMPLEADOS (TODOS) ===")
        count = 0
        for result in cur.stored_results():
            for (id_, nombre, cargo, sueldo, eliminado, created_at, updated_at, deleted_at) in result.fetchall():
                count += 1
                estado = "ACTIVO" if eliminado == 0 else "ELIMINADO"
                ua = updated_at if updated_at is not None else "-"
                da = deleted_at if deleted_at is not None else "-"
                print(
                    f"ID:{id_:<3} | Nombre:{nombre:<15} | Cargo:{cargo:<13} | "
                    f"Sueldo:${sueldo:,.0f} | {estado:<9} | Creado:{created_at} | "
                    f"Actualizado:{ua} | Eliminado:{da}"
                )
        if count == 0:
            print("No hay empleados en la base de datos.")
    except mysql.connector.Error as e:
        print("❌ Error en sp_listar_todos:", e)
    finally:
        if cur: cur.close()
        if cnx and cnx.is_connected(): cnx.close()

def sp_borrado_logico(id_empleado: int):
    """
    Marca un empleado como eliminado lógicamente llamando al procedimiento:
    sp_borrado_logico_empleado(IN p_id)
    """
    cnx = cur = None
    try:
        cnx = conectar()
        cur = cnx.cursor()
        cur.callproc("sp_borrado_logico_empleado", [id_empleado])
        cnx.commit()
        print(f"✅ Borrado lógico aplicado al ID {id_empleado} (si estaba activo).")
    except mysql.connector.Error as e:
        print("❌ Error en sp_borrado_logico:", e)
        if cnx and cnx.is_connected():
            try: cnx.rollback()
            except: pass
    finally:
        if cur: cur.close()
        if cnx and cnx.is_connected(): cnx.close()

def sp_restaurar(id_empleado: int):
    """
    Restaura un empleado eliminado lógicamente llamando a:
    sp_restaurar_empleado(IN p_id)
    """
    cnx = cur = None
    try:
        cnx = conectar()
        cur = cnx.cursor()
        cur.callproc("sp_restaurar_empleado", [id_empleado])
        cnx.commit()
        print(f"✅ Restaurado ID {id_empleado} (si estaba eliminado).")
    except mysql.connector.Error as e:
        print("❌ Error en sp_restaurar:", e)
        if cnx and cnx.is_connected():
            try: cnx.rollback()
            except: pass
    finally:
        if cur: cur.close()
        if cnx and cnx.is_connected(): cnx.close()

# ----------------- NUEVAS FUNCIONES (6, 7, 8, 9) -----------------

def sp_actualizar(id_emp: int, nombre: str, cargo: str, sueldo: float):
    """
    (NUEVA FUNCIÓN 6)
    Actualiza los datos de un empleado existente llamando a:
    sp_actualizar_empleado(IN p_id, IN p_nombre, IN p_cargo, IN p_sueldo)
    """
    cnx = cur = None
    try:
        cnx = conectar()
        cur = cnx.cursor()
        args = [id_emp, nombre, cargo, sueldo]
        cur.callproc("sp_actualizar_empleado", args)
        cnx.commit()
        print(f"✅ Empleado ID {id_emp} actualizado correctamente.")
    except mysql.connector.Error as e:
        print("❌ Error en sp_actualizar:", e)
        if cnx and cnx.is_connected():
            try: cnx.rollback()
            except: pass
    finally:
        if cur: cur.close()
        if cnx and cnx.is_connected(): cnx.close()

def sp_buscar_por_id(id_empleado: int):
    """
    (NUEVA FUNCIÓN 7)
    Busca y muestra un empleado específico por su ID llamando a:
    sp_buscar_empleado_por_id(IN p_id)
    """
    cnx = cur = None
    try:
        cnx = conectar()
        cur = cnx.cursor()
        cur.callproc("sp_buscar_empleado_por_id", [id_empleado])
        print(f"\n=== DETALLE EMPLEADO ID: {id_empleado} ===")
        
        empleado_encontrado = None
        for result in cur.stored_results():
            empleado_encontrado = result.fetchone() # fetchone() porque es un solo ID
        
        if empleado_encontrado:
            (id_, nombre, cargo, sueldo, eliminado, created_at, updated_at, deleted_at) = empleado_encontrado
            
            estado = "ACTIVO" if eliminado == 0 else "ELIMINADO"
            ua = updated_at if updated_at is not None else "-"
            da = deleted_at if deleted_at is not None else "-"
            
            print(f"ID:          {id_}")
            print(f"Nombre:      {nombre}")
            print(f"Cargo:       {cargo}")
            print(f"Sueldo:      ${sueldo:,.0f}")
            print(f"Estado:      {estado}")
            print(f"Creado:      {created_at}")
            print(f"Actualizado: {ua}")
            print(f"Eliminado:   {da}")
        else:
            print(f"No se encontró ningún empleado con el ID {id_empleado}.")
            
    except mysql.connector.Error as e:
        print("❌ Error en sp_buscar_por_id:", e)
    finally:
        if cur: cur.close()
        if cnx and cnx.is_connected(): cnx.close()

def sp_listar_eliminados():
    """
    (NUEVA FUNCIÓN 8)
    Llama al procedimiento almacenado sp_listar_empleados_eliminados().
    Muestra solo los registros eliminados lógicamente (eliminado = 1).
    """
    cnx = cur = None
    try:
        cnx = conectar()
        cur = cnx.cursor()
        cur.callproc("sp_listar_empleados_eliminados")
        print("\n=== EMPLEADOS ELIMINADOS (LÓGICO) ===")
        count = 0
        for result in cur.stored_results():
            # El SP solo devuelve 4 columnas (ver SQL)
            for (id_, nombre, cargo, deleted_at) in result.fetchall():
                count += 1
                da = deleted_at if deleted_at is not None else "Fecha no registrada"
                print(f"ID:{id_:<3} | Nombre:{nombre:<15} | Cargo:{cargo:<13} | Eliminado en:{da}")
        
        if count == 0:
            print("No se encontraron empleados eliminados.")
            
    except mysql.connector.Error as e:
        print("❌ Error en sp_listar_eliminados:", e)
    finally:
        if cur: cur.close()
        if cnx and cnx.is_connected(): cnx.close()

def sp_borrado_fisico(id_empleado: int):
    """
    (NUEVA FUNCIÓN 9)
    Elimina PERMANENTEMENTE un registro de la base de datos llamando a:
    sp_borrado_fisico_empleado(IN p_id)
    """
    cnx = cur = None
    try:
        cnx = conectar()
        cur = cnx.cursor()
        cur.callproc("sp_borrado_fisico_empleado", [id_empleado])
        cnx.commit()
        print(f"✅ Borrado FÍSICO aplicado al ID {id_empleado}. El registro fue eliminado permanentemente.")
    except mysql.connector.Error as e:
        print("❌ Error en sp_borrado_fisico:", e)
        if cnx and cnx.is_connected():
            try: cnx.rollback()
            except: pass
    finally:
        if cur: cur.close()
        if cnx and cnx.is_connected(): cnx.close()

# ---------------- MENÚ PRINCIPAL (Actualizado) ----------------
def menu():
    """
    Muestra un menú interactivo en consola con 9 opciones.
    """
    while True:
        print("\n===== MENÚ EMPLEADOS (MySQL + SP) =====")
        print("--- CRUD ---")
        print("1) Insertar empleado (Create)")
        print("2) Listar empleados ACTIVOS (Read)")
        print("6) Actualizar empleado por ID (Update)")
        print("4) Borrado lógico por ID (Delete)")
        print("--- UTILIDADES ---")
        print("7) Buscar empleado por ID")
        print("3) Listar empleados (TODOS)")
        print("8) Listar empleados ELIMINADOS")
        print("5) Restaurar por ID")
        print("--- ZONA PELIGROSA ---")
        print("9) Borrado FÍSICO por ID (¡IRREVERSIBLE!)")
        print("---------------------------------------")
        print("0) Salir")

        opcion = input("Selecciona una opción: ").strip()

        # --- Opción 1: Insertar ---
        if opcion == "1":
            nombre = input("Nombre: ").strip()
            cargo  = input("Cargo: ").strip()
            try:
                sueldo = float(input("Sueldo (ej: 750000): ").strip())
                if not nombre or not cargo: # Validación simple
                    print("❌ El nombre y el cargo no pueden estar vacíos.")
                    continue
            except ValueError:
                print("❌ Sueldo inválido.")
                continue
            sp_insertar(nombre, cargo, sueldo)

        # --- Opción 2: Listar Activos ---
        elif opcion == "2":
            sp_listar_activos()

        # --- Opción 3: Listar Todos ---
        elif opcion == "3":
            sp_listar_todos()

        # --- Opción 4: Borrado Lógico ---
        elif opcion == "4":
            try:
                id_emp = int(input("ID a eliminar lógicamente: ").strip())
            except ValueError:
                print("❌ ID inválido.")
                continue
            sp_borrado_logico(id_emp)

        # --- Opción 5: Restaurar ---
        elif opcion == "5":
            try:
                id_emp = int(input("ID a restaurar: ").strip())
            except ValueError:
                print("❌ ID inválido.")
                continue
            sp_restaurar(id_emp)

        # --- (NUEVA) Opción 6: Actualizar ---
        elif opcion == "6":
            try:
                id_emp = int(input("ID del empleado a actualizar: ").strip())
            except ValueError:
                print("❌ ID inválido.")
                continue
            
            print(f"--- Ingresa los NUEVOS datos para el ID {id_emp} ---")
            try:
                nombre_act = input("Nuevo Nombre: ").strip()
                cargo_act  = input("Nuevo Cargo: ").strip()
                sueldo_act = float(input("Nuevo Sueldo: ").strip())
                
                if not nombre_act or not cargo_act:
                    print("❌ El nombre y el cargo no pueden estar vacíos.")
                    continue
                
                sp_actualizar(id_emp, nombre_act, cargo_act, sueldo_act)
            except ValueError:
                print("❌ Sueldo inválido.")
                continue

        # --- (NUEVA) Opción 7: Buscar por ID ---
        elif opcion == "7":
            try:
                id_emp = int(input("ID del empleado a buscar: ").strip())
            except ValueError:
                print("❌ ID inválido.")
                continue
            sp_buscar_por_id(id_emp)

        # --- (NUEVA) Opción 8: Listar Eliminados ---
        elif opcion == "8":
            sp_listar_eliminados()

        # --- (NUEVA) Opción 9: Borrado FÍSICO ---
        elif opcion == "9":
            try:
                id_emp = int(input("ID a eliminar FÍSICAMENTE: ").strip())
            except ValueError:
                print("❌ ID inválido.")
                continue
            
            confirm = input(f"🚨 ¿Estás seguro de borrar PERMANENTEMENTE el ID {id_emp}? "
                            "Esta acción no se puede deshacer. Escribe 'SI' para confirmar: ").strip()
            
            if confirm == "SI":
                sp_borrado_fisico(id_emp)
            else:
                print("Operación cancelada.")

        # --- Opción 0: Salir ---
        elif opcion == "0":
            print("👋 Saliendo del sistema...")
            break

        # --- Opción no válida ---
        else:
            print("❌ Opción no válida. Intenta nuevamente.")

# Punto de entrada del programa
if __name__ == "__main__":
    menu()