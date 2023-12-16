
--Sample - 1
PROCEDURE run_search(i_unit_id           IN lu_unit.fsu_id%TYPE,
                     i_equipment         IN tbl_component.component%TYPE,
                     i_equipment_status  IN tbl_component.equipment_status%TYPE,
                     i_equipment_type    IN tbl_component.equipment_type%TYPE,
                     i_equipment_subtype IN tbl_component.equipment_sub_type%TYPE,
                     i_system_id         IN tbl_component.system_id%TYPE,
                     i_association_code  IN tbl_component_assc_code.assc_code%TYPE,
                     i_manufacturer      IN lu_component_manu_model.equipment_manufacturer%TYPE,
                     i_manumodel         IN lu_component_manu_model.equipment_model%TYPE,
                     o_results           OUT sys_refcursor) AS
BEGIN
  OPEN o_results FOR
    SELECT rownum, results.*
      FROM (SELECT count(*) OVER() as total_results,
                   site_id,
                   site_display_name,
                   unit_id,
                   unit_display_name,
                   system_id,
                   system_display_name,
                   component_id,
                   component,
                   component_description,
                   equipment_description,
                   equipment_status,
                   equipment_model,
                   equipment_serial_number,
                   equipment_type,
                   equipment_sub_type,
                   template_ids
              FROM vw_component_search
             WHERE (i_unit_id IS NULL OR unit_id = i_unit_id)
               AND (i_equipment IS NULL OR
                   lower(component) LIKE '%' || lower(i_equipment) || '%')
               AND (i_equipment_status IS NULL OR
                   equipment_status = i_equipment_status)
               AND (i_equipment_type IS NULL OR
                   equipment_type = i_equipment_type)
               AND (i_equipment_subtype IS NULL OR
                   equipment_sub_type = i_equipment_subtype)
               AND (i_system_id IS NULL OR system_id = i_system_id)
               AND (i_association_code IS NULL OR EXISTS
                    (select null
                       from tbl_component_assc_code
                      where assc_code = i_association_code
                        and component_id = vcs.component_id))
               AND (i_manufacturer IS NULL OR
                   equipment_manufacturer = i_manufacturer)
               AND (i_manuModel IS NULL OR equipment_model = i_manuModel)
             ORDER BY unit_display_name, component) results;
END run_search;
