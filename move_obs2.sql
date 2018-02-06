use amrs;
drop PROCEDURE if exists move_obs;
DELIMITER //
 CREATE PROCEDURE move_obs(IN off_set int unsigned, IN max_offset int unsigned)
   BEGIN
   declare batch_size int unsigned default 1000000;
  SET batch_size = 1000000;
  SET FOREIGN_KEY_CHECKS = 0;
SET UNIQUE_CHECKS = 0;
SET AUTOCOMMIT = 0;
SELECT NOW();
WHILE off_set < max_offset DO
   select off_set , now() as starting_time;
       INSERT INTO amrs.obs
(select 
`obs_id`,
`person_id`,
`concept_id`,
`encounter_id`,
`order_id`,
`obs_datetime`,
`location_id`,
`obs_group_id`,
`accession_number`,
`value_group_id`,
`value_coded`,
`value_coded_name_id`,
`value_drug`,
`value_datetime`,
`value_numeric`,
`value_modifier`,
`value_text`,
`comments`,
`creator`,
`date_created`,
`voided`,
`voided_by`,
`date_voided`,
`void_reason`,
`value_complex`,
`uuid`,
`previous_version`,
`form_namespace_and_path`
,"FINAL",null
from amrs.obs_old limit batch_size offset off_set
);
SET off_set = off_set + batch_size;
END WHILE;
SELECT off_set AS final_offset;
SET UNIQUE_CHECKS = 1;
SET FOREIGN_KEY_CHECKS = 1;
COMMIT;
   END //
 DELIMITER ;