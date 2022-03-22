import javax.xml.transform.Result;
import java.io.IOException;
import java.sql.*;

public class Main {
    public static void main(String[] args) {
        System.out.println("\n");
        System.out.println("############");
        System.out.println("Erwtima a");
        System.out.println("############");
        System.out.println("\n");

        connect("""
                select dri.full_name as driver, cu.full_name as customer,\s
                	   co.contract_code as contract, co.start_date\s
                from drivers dr1 join drivers_info dri on dr1.license_number = dri.license_number
                	join contracts co on co.license_plate = dr1.license_plate
                	join customers cu on co.customer_id = cu.customer_id
                where date_part('month', current_date) - date_part('month', co.start_date) = 1
                	and date_part('year', current_date) = date_part('year', co.start_date);""", "a");

        System.out.println("\n");
        System.out.println("############");
        System.out.println("Erwtima b");
        System.out.println("############");
        System.out.println("\n");
        connect("""
                select co.contract_code, co.end_date,\s
                	   cu.full_name, cu.phone_number, cu.cell_phone
                from contracts co join customers cu\s
                	 on co.customer_id = cu.customer_id
                where date_part('month', co.end_date) - date_part('month', current_date) = 1\s
                	and date_part('year', current_date) = date_part('year', co.end_date);""","b");

        System.out.println("\n");
        System.out.println("############");
        System.out.println("Erwtima c Parallagh: pou ypegrafhsan");
        System.out.println("############");
        System.out.println("\n");
        connect("""
                select date_part('year', start_date) as "year", contract_group, count(*) as "signed"
                from contracts
                where date_part('year', start_date) >= 2016\s
                	and date_part('year', start_date) <= 2020
                group by date_part('year', start_date), contract_group""","c1");

        System.out.println("\n");
        System.out.println("############");
        System.out.println("Erwtima c Parallagh: pou den ananewthikan");
        System.out.println("############");
        System.out.println("\n");
        connect("""
                select date_part('year', end_date) as "year", contract_group, count(*) as "not update"
                from contracts
                where date_part('year', end_date) >= 2016\s
                	and date_part('year', end_date) <= 2020
                group by date_part('year', end_date), contract_group""","c2");


        System.out.println("\n");
        System.out.println("############");
        System.out.println("Erwtima d");
        System.out.println("############");
        System.out.println("\n");
        connect("""
                select contract_group, sum(cost) as total_cost, count(*) as amount,\s
                	(sum(cost) / count(*)::decimal(100,2))::decimal(100,2) as "reduction based on # of contracts"
                from contracts
                group by contract_group
                order by count(*) desc""", "d");

        System.out.println("\n");
        System.out.println("############");
        System.out.println("Erwtima e");
        System.out.println("############");
        System.out.println("\n");
        connect("""
                select\s
                	(count(*) filter (where date_part('year', current_date) - veinfo.first_release <= 4) / count(*)::decimal(100,2))::decimal(100,3) as "0-4 years",
                	(count(*) filter (where date_part('year', current_date) - veinfo.first_release >= 5 and date_part('year', current_date) - veinfo.first_release <= 9) / count(*)::decimal(100,3))::decimal(100,3) as "5-9 years",
                	(count(*) filter (where date_part('year', current_date) - veinfo.first_release >= 10 and date_part('year', current_date) - veinfo.first_release <= 19) / count(*)::decimal(100,3))::decimal(100,3) as "10-19 years",
                	(count(*) filter (where date_part('year', current_date) - veinfo.first_release >= 20) / count(*)::decimal(100,2))::decimal(100,3) as "20+ years"
                from vehicles ve join contracts co on ve.license_plate = co.license_plate
                	join vehicles_info veinfo on veinfo.model_id = ve.model_id""", "e");

        System.out.println("\n");
        System.out.println("############");
        System.out.println("Erwtima f");
        System.out.println("############");
        System.out.println("\n");
        connect("""
                select\s
                	(count(*) filter (where date_part('year', current_date) - date_part('year', birthday) >= 18 and date_part('year', current_date) - date_part('year', birthday) <= 24) / count(*)::decimal(100,2))::decimal(100,3) as "18-24 years old",
                	(count(*) filter (where date_part('year', current_date) - date_part('year', birthday) >= 25 and date_part('year', current_date) - date_part('year', birthday) <= 49) / count(*)::decimal(100,2))::decimal(100,3) as "25-49 years old",
                	(count(*) filter (where date_part('year', current_date) - date_part('year', birthday) >= 50 and date_part('year', current_date) - date_part('year', birthday) <= 69) / count(*)::decimal(100,2))::decimal(100,3) as "50-69 years old",
                	(count(*) filter (where date_part('year', current_date) - date_part('year', birthday) >= 70) / count(*)::decimal(100,2))::decimal(100,3) as "70+ years old"
                from drivers_violations dv join drivers_info di\s
                	on dv.license_number = di.license_number""", "f");
    }


    static void connect(String query, String erwtima){
        try {
            String url = "jdbc:postgresql://localhost:5432/insu";
            String user = "postgres";
            String pass = "john00612000";
            Connection conn = DriverManager.getConnection(url, user, pass);
            Statement stmt = conn.createStatement();

            ResultSet rs = stmt.executeQuery(query);
            ResultSetMetaData rsmd = rs.getMetaData();
            int columnsNumber = rsmd.getColumnCount();
            while (rs.next()) {
                if (erwtima.equals("a")) {
                    System.out.println("Driver: " + rs.getString(1));
                    System.out.println("Customer: " + rs.getString(2));
                    System.out.println("Contract: " + rs.getString(3));
                    System.out.println("Start date: " + rs.getString(4));
                    System.out.println("-----------------------------");
                } else if (erwtima.equals("b")){
                    System.out.println("Contract code: " + rs.getString(1));
                    System.out.println("End date: " + rs.getString(2));
                    System.out.println("Full name: " + rs.getString(3));
                    System.out.println("Phone number: " + rs.getString(4));
                    System.out.println("Cell phone: " + rs.getString(5));
                    System.out.println("-----------------------------");
                } else if (erwtima.equals("c1")){
//                    System.out.println("Year: " + rs.getString(1));
//                    System.out.println("Contract group: " + rs.getString(2));
//                    System.out.println("Amount: " + rs.getString(3));
//                    System.out.println("-----------------------------");
                    for (int i = 1; i <= columnsNumber; i++){
                        if ( i > 1 ) System.out.println(",  ");
                        String columnValue = rs.getString(i);
                        System.out.println(columnValue + " " + rsmd.getColumnName(i));
                    }
                    System.out.println("");

                } else if (erwtima.equals("c2")){
                    System.out.println("Year: " + rs.getString(1));
                    System.out.println("Contract group: " + rs.getString(2));
                    System.out.println("Amount: " + rs.getString(3));
                    System.out.println("-----------------------------");
                } else if (erwtima.equals("d")){
                    System.out.println("Contract group: " + rs.getString(1));
                    System.out.println("Total cost: " + rs.getString(2));
                    System.out.println("Amount: " + rs.getString(3));
                    System.out.println("-----------------------------");
                } else if (erwtima.equals("e")){
                    System.out.println("0-4 Years: " + rs.getString(1));
                    System.out.println("5-9 Years: " + rs.getString(2));
                    System.out.println("10-19 Years: " + rs.getString(3));
                    System.out.println("20+ Years: " + rs.getString(4));
                } else if (erwtima.equals("f")){
                    System.out.println("18-24 Years old: " + rs.getString(1));
                    System.out.println("25-49 Years old: " + rs.getString(2));
                    System.out.println("50-69 Years old: " + rs.getString(3));
                    System.out.println("70+ Years old: " + rs.getString(4));
                }
            }

            rs.close();
            stmt.close();
            conn.close();

        } catch (SQLException throwables) {
            throwables.printStackTrace();
        }
    }
}
