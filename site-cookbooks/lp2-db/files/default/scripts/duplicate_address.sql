delete from address where id in (select min(id) as id from address where person_id in (select  person_id from address group by person_id having count(*) > 1) group by person_id);
