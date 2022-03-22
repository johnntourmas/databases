
-- a. Ποια (νέα) συμβόλαια υπεγράφησαν τον τελευταίο μήνα και ποιοι είναι οι πελάτες και 
-- οι οδηγοί που σχετίζονται με αυτά

select dri.full_name as driver, cu.full_name as customer, 
	   co.contract_code as contract, co.start_date 
from drivers dr1 join drivers_info dri on dr1.license_number = dri.license_number
	join contracts co on co.license_plate = dr1.license_plate
	join customers cu on co.customer_id = cu.customer_id
where date_part('month', current_date) - date_part('month', co.start_date) = 1
	and date_part('year', current_date) = date_part('year', co.start_date);

	
-- b. Ποια συμβόλαια αναμένεται να λήξουν τον επόμενο μήνα και ποια είναι τα τηλέφωνα 
-- επικοινωνίας των πελατών που σχετίζονται με αυτά.

select co.contract_code, co.end_date, 
	   cu.full_name, cu.phone_number, cu.cell_phone
from contracts co join customers cu 
	 on co.customer_id = cu.customer_id
where date_part('month', co.end_date) - date_part('month', current_date) = 1 
	and date_part('year', current_date) = date_part('year', co.end_date);

-- c. Ποιος είναι ο αριθμός των συμβολαίων που υπεγράφησαν (παραλλαγή: που δεν 
-- ανανεώθηκαν) ανά ασφαλιστική κατηγορία και ανά έτος για την πενταετία 2016-2020.

-- παραλλαγη: που υπεγράφησαν
select date_part('year', start_date) as "year", contract_group, count(*) as "signed"
from contracts
where date_part('year', start_date) >= 2016 
	and date_part('year', start_date) <= 2020
group by date_part('year', start_date), contract_group

-- παραλλαγη: που δεν ανανεώθηκαν
select date_part('year', end_date) as "year", contract_group, count(*) as "not updateδ"
from contracts
where date_part('year', end_date) >= 2016 
	and date_part('year', end_date) <= 2020
group by date_part('year', end_date), contract_group


-- d. Ποια κατηγορία ασφάλισης παρουσιάζει βάσει των συμβολαίων τον μεγαλύτερο τζίρο
-- (2 παραλλαγές: σε απόλυτους αριθμούς, με αναγωγή βάσει πλήθους συμβολαίων).

select contract_group, sum(cost) as total_cost, count(*) as amount, 
	(sum(cost) / count(*)::decimal(100,2))::decimal(100,2) as "reduction based on # of contracts"
from contracts
group by contract_group
order by count(*) desc

-- e. Ποιος είναι ο μέσος όρος συμβολαίων ανά ηλικιακή ομάδα οχημάτων (παλαιότητα 0-4 
-- έτη, 5-9 έτη, 10-19 έτη, 20+ έτη).

-- ειναι συμβολαια σε ομαδα οχηματων / συνολο συμβολαιων  
select 
	(count(*) filter (where date_part('year', current_date) - veinfo.first_release <= 4) / count(*)::decimal(100,2))::decimal(100,3) as "0-4 years",
	(count(*) filter (where date_part('year', current_date) - veinfo.first_release >= 5 and date_part('year', current_date) - veinfo.first_release <= 9) / count(*)::decimal(100,3))::decimal(100,3) as "5-9 years",
	(count(*) filter (where date_part('year', current_date) - veinfo.first_release >= 10 and date_part('year', current_date) - veinfo.first_release <= 19) / count(*)::decimal(100,3))::decimal(100,3) as "10-19 years",
	(count(*) filter (where date_part('year', current_date) - veinfo.first_release >= 20) / count(*)::decimal(100,2))::decimal(100,3) as "20+ years"
from vehicles ve join contracts co on ve.license_plate = co.license_plate
	join vehicles_info veinfo on veinfo.model_id = ve.model_id

-- f. Ποιος είναι ο μέσος όρος συμβάντων-παραβάσεων ανά ηλικιακή ομάδα οδηγών (18-
-- 24, 25-49, 50-69, 70+).

-- ειναι παραβασεις στις ηλικιες x εως y / συνολο παραβασεων  
-- αν τρακαρουν δυο οχηματα, αυτο το μετραμε σαν 2 παραβασεις

select 
	(count(*) filter (where date_part('year', current_date) - date_part('year', birthday) >= 18 and date_part('year', current_date) - date_part('year', birthday) <= 24) / count(*)::decimal(100,2))::decimal(100,3) as "18-24 years old",
	(count(*) filter (where date_part('year', current_date) - date_part('year', birthday) >= 25 and date_part('year', current_date) - date_part('year', birthday) <= 49) / count(*)::decimal(100,2))::decimal(100,3) as "25-49 years old",
	(count(*) filter (where date_part('year', current_date) - date_part('year', birthday) >= 50 and date_part('year', current_date) - date_part('year', birthday) <= 69) / count(*)::decimal(100,2))::decimal(100,3) as "50-69 years old",
	(count(*) filter (where date_part('year', current_date) - date_part('year', birthday) >= 70) / count(*)::decimal(100,2))::decimal(100,3) as "70+ years old"
from drivers_violations dv join drivers_info di 
	on dv.license_number = di.license_number	