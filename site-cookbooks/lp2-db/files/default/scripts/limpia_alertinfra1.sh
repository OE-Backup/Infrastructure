hoy=$(date +%Y-%m-%d)
pg_dump  -t personcourse -t PersonProgression -t PersonUnitProgression lp20 > /mnt/postgresql/pg_dump/bkp.limpia_infralert1.$hoy.sql
psql -d lp20 -c "update personcourse 			set status='ACTIVE' 						where person_id=(select id  from person where accountname='alertinfra1') ;             ";
psql -d lp20 -c "update PersonProgression 		set units=0 , complete=false , active=true 	where person_id=(select id  from person where accountname='alertinfra1') AND level_id=1 ; ";
psql -d lp20 -c "update PersonUnitProgression 	set lessons=0 , complete=false  			where personprogression_id=(select id  from person where accountname='alertinfra1');  ";

