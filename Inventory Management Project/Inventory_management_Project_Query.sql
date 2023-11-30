SELECT * FROM inventory_management.spares_inventory;

#1. Create schema named spares inventory
CREATE SCHEMA spares_inventory;

#2. Create table named spares inventory
create table spares_inventory
(
    Sr_No                      int         not null
        primary key,
    Storage_locatiojn          int         null,
    Material_Group             int         null,
    External_Material          varchar(45) null,
    Material_Number            int         null,
    Material_Description       varchar(45) null,
    UoM                        varchar(45) null,
    Unrestricted               int         null,
    Value_Unrestricted         int         null,
    Currency                   varchar(45) null,
    External_Material_Group    int         null,
    Asset_Manufacturer         varchar(45) null,
    Model_number               varchar(45) null,
    Manufacturer_Part_Number   varchar(45) null,
    Sub_assembly               varchar(45) null,
    Material_Group_Description varchar(45) null,
    Batch                      varchar(45) null
);

#3. Finding the number of rows
SELECT COUNT(*) FROM spares_inventory;

#4. Finding the number of columns
SELECT COUNT(*) FROM information_schema.columns
	WHERE TABLE_NAME = "spares_inventory";
    
#5. Finding the different storage location from the table spares inventory
SELECT DISTINCT Storage_location FROM spares_inventory;

#6. Now we need fo find the different External material from the table
SELECT DISTINCT External_Material FROM spares_inventory;

#7. Now we are looking for the different asset manufacturer from the table
SELECT DISTINCT Asset_Manufacturer FROM spares_inventory;

#8. In the above query there are many rows so we want to find the different number of rows from the table
SELECT COUNT( DISTINCT Asset_Manufacturer) FROM spares_inventory;

#9. 
DELETE FROM spares_inventory WHERE Sr_No = 1;

#10. Here we want to find the materials, which are not present in unrestricted stock
SELECT * FROM spares_inventory
	WHERE Unrestricted = 0;
    
#11. Here we want to find the materials, which are present in unrestricted stock
SELECT * FROM spares_inventory
	WHERE Unrestricted != 0;

#12. Counting the number of material counting more than 5 after grouping by material group.
SELECT Material_Group, 
		COUNT(*) 
        FROM spares_inventory 
        GROUP BY Material_Group 
        HAVING COUNT(*) > 5;
        
#13. Making the new column based on the number of material
SELECT Material_Description,
    CASE
        WHEN Material_Number < 100 THEN 'Low'
        WHEN Material_Number < 500 THEN 'Medium'
        ELSE 'High'
    END AS Material_Level
FROM spares_inventory;

#14. Finding the rows with null values.
SELECT *
FROM spares_inventory
WHERE Material_Description IS NULL;
    
#15. Now we want to find the total unrestricted quantity of stock which are present in the storage location 1000
SELECT Storage_location, SUM(Unrestricted) AS Total_Quantity FROM spares_inventory
    GROUP BY Storage_location
    ORDER BY Total_Quantity;

#16. Here we are finding the total unrestricted quantity by grouping by External quantity
SELECT External_Material, SUM(Unrestricted) AS Total_quantity
	FROM spares_inventory
    GROUP BY External_Material
    ORDER BY Total_quantity DESC;

#17. From the above query if we want to find the External material with maximum quantity 
SELECT * FROM (SELECT External_Material, SUM(Unrestricted) AS Total_quantity
	FROM spares_inventory 
		GROUP BY External_Material
			ORDER BY Total_quantity DESC) x
WHERE x.Total_quantity IN (SELECT MAX(x.Total_quantity) FROM (SELECT External_Material, SUM(Unrestricted) AS Total_quantity
	FROM spares_inventory 
		GROUP BY External_Material
			ORDER BY Total_quantity DESC) x); 
            
#18. We are going to find the sum of the unrestricted value after grouping the table by External Material
SELECT External_Material, SUM(Value_Unrestricted) AS Total_value
	FROM spares_inventory
		GROUP BY External_Material
			ORDER BY Total_value DESC;
    
#19. Now we are going to find the sum of the unrestricted value and find the maximum from the same after gourping the table by External Material
SELECT * FROM (SELECT External_Material, SUM(Value_Unrestricted) AS Total_value
	FROM spares_inventory
		GROUP BY External_Material
			ORDER BY Total_value DESC) x
    WHERE x.Total_value IN (SELECT MAX(x.Total_value) FROM (SELECT External_Material, SUM(Value_Unrestricted) AS Total_value
	FROM spares_inventory
		GROUP BY External_Material
			ORDER BY Total_value DESC) x);

#20. NOw we want to find the material
SELECT *
	FROM spares_inventory
		WHERE Material_Description = 'HOSE';

#21. If we want to create a derived column based on the availaibility of material
SELECT * FROM ( 
				SELECT *, 
					CASE
						WHEN Unrestricted = 0 THEN "Matrial Out of Stock"
						ELSE "Material in Stock"
					END AS Status_of_material
				FROM spares_inventory
                ) x
	WHERE x.Status_of_material = "Matrial Out of Stock";

#22. If in the above query we want to find the count of the material which are out of stock and based on that we need to re-order
SELECT Count(*) AS Total_Out_of_stock_material FROM ( 
				SELECT *, 
					CASE
						WHEN Unrestricted = 0 THEN "Matrial Out of Stock"
						ELSE "Material in Stock"
					END AS Status_of_material
				FROM spares_inventory
                ) x
	WHERE x.Status_of_material = "Matrial Out of Stock";
        
#23. Now we want to find the FOC material list
SELECT * FROM
	spares_inventory
		WHERE Batch IN ("FOC");
        
#24. If we want to find out the materials whose value is greater than the average value.
SELECT *
	FROM spares_inventory
		WHERE Value_Unrestricted > (SELECT AVG(Value_Unrestricted) FROM spares_inventory);

#25. 
SELECT *, COUNT(UoM) AS Total_Count FROM (
				SELECT UoM FROM spares_inventory
                WHERE UoM = "NOS" 
				) x ;

