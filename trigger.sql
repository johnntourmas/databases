-- trigger για ερώτημα 3 a
drop trigger update_p_contracts on contracts;


create trigger update_p_contracts
after insert or delete on contracts
for each row execute procedure p_contracts();


create or replace function p_contracts() returns trigger
language plpgsql as $$
declare
begin
	update contracts 
	set end_date = end_date + interval '1 year'
	where end_date = current_date and contract_group = 'professional';
	return new;
end;
$$ 

-- testarisma
select * from contracts where contract_code = 'IBWNN86573'

delete from contracts where contract_code = 'IBWNN86573'

insert into contracts (contract_code, license_plate, contract_group, cost, start_date, end_date, customer_id) 
values ('IBWNN86573', '465-HCJ', 'professional', 3983.2, '2019-05-23', '2021-05-26', '30828RHLO');

-- trigger για να δηλώνει αυτόματα αν ένα συμβόλαιο
-- είναι ενεργό ή όχι
drop trigger check_date on contracts;

create trigger check_date
after insert or delete on contracts
for each row execute procedure categ_contracts();

create or replace function categ_contracts() returns trigger
language plpgsql as $$
declare
begin
	if new.end_date < current_date then
		update contracts set contract_category = 'not active';
		return new;
	else
		update contracts set contract_category = 'active';
		return new;
	end if;
end;
$$ 