-- b. Ποια συμβόλαια αναμένεται να λήξουν τον επόμενο μήνα και ποια είναι τα τηλέφωνα 
-- επικοινωνίας των πελατών που σχετίζονται με αυτά.
select co.contract_code, co.end_date, cu.full_name, cu.phone_number, cu.cell_phone
from contracts co join customers cu on co.customer_id = cu.customer_id
where date_part('month', co.end_date) - date_part('month', current_date) = 1 and
	 date_part('year', current_date) = date_part('year', co.end_date);
	 

create or replace function print_solution() 
returns table(contract_code varchar(50), end_date date, full_name varchar(100), phone_number varchar(50), cell_phone varchar(50)) as $$
declare
	c1 cursor for select * from contracts;
	c2 cursor for select * from customers;
	r1 contracts%rowtype;
	r2 customers%rowtype;
	cnt int := 0;
begin
	create table one_month(
		contract_code varchar(50) primary key,
		end_date date not null,
		full_name varchar(100) not null,
		phone_number varchar(50),
		cell_phone varchar(50));
	open c1;
	loop
		fetch c1 into r1;
		exit when not found;
		if date_part('month',r1.end_date) - 1 = date_part('month', current_date) and date_part('year',r1.end_date) = date_part('year', current_date) then
			open c2;
			loop
				fetch c2 into r2;
				exit when not found;
				if r1.customer_id = r2.customer_id then
					insert into one_month values(r1.contract_code, r1.end_date, r2.full_name, r2.phone_number, r2.cell_phone);
				end if;			
			end loop;
			close c2;
		end if;
	end loop;
	close c1;
	return query select * from one_month;
end; $$
language 'plpgsql';	
			
select * from print_solution();

DROP FUNCTION print_solution();
drop table if exists one_month;