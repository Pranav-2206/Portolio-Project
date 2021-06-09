use Project; 
-- converting date in a similar format
select convert(date, saledate) from Nashville;


alter table nashville add saledate2 date; 
select *from nashville;

update nashville set saledate2 = convert(date, saledate); 


-- populating Property address
select * from nashville  order by ParcelID; 

select a.ParcelId, a.PropertyAddress, b.ParcelId, b.PropertyAddress, isnull(a.PropertyAddress, b.PropertyAddress) 
from Nashville a join Nashville b on a.ParcelId = b.ParcelId and a.uniqueid <> b.uniqueid 
where a.PropertyAddress is null;

update a
set PropertyAddress = isnull(a.PropertyAddress, b.PropertyAddress) 
from Nashville a join Nashville b on a.ParcelId = b.ParcelId and a.uniqueid <> b.uniqueid 
where a.PropertyAddress is null;



-- Breaking out Address into Individual Columns (Address, City, State)

--Formatting/Splitting [PropertyAddress]
select propertyaddress from nashville; 

select SUBSTRING(propertyaddress, 1, charindex(',', propertyaddress)-1) 
from nashville; 
select SUBSTRING(propertyaddress, charindex(',', propertyaddress) + 1 , len(propertyaddress)) 
from nashville; 

Alter table nashville add SplitAddress nvarchar(255); 
update Nashville set SplitAddress = SUBSTRING(propertyaddress, 1, charindex(',', propertyaddress)-1) 
from nashville;

Alter table nashville add SplitCity nvarchar(255); 
update Nashville set SplitCity = SUBSTRING(propertyaddress, charindex(',', propertyaddress) + 1 , len(propertyaddress)) 
from nashville; 

select *from Nashville


--Formatting/Splitting OwnerAddress 
select OwnerAddress from Nashville; 

select Parsename(replace(owneraddress, ',', '.'), 3)
from nashville; 
select Parsename(replace(owneraddress, ',', '.'), 2)
from nashville;
select Parsename(replace(owneraddress, ',', '.'), 1)
from Nashville;



Alter table Nashville add OwnerSplitAddress nvarchar(255);
update nashville set OwnerSplitAddress = Parsename(replace(owneraddress, ',', '.'), 3)
from nashville; 


Alter table Nashville add OwnerSplitCity nvarchar(255);
update nashville set OwnerSplitCity = Parsename(replace(owneraddress, ',', '.'), 2)
from nashville; 


Alter table Nashville add OwnerSplitState nvarchar(255);
update nashville set OwnerSplitState = Parsename(replace(owneraddress, ',', '.'), 1)
from nashville; 



--Analysing SoldAsVaccant 
select soldasvacant, count(soldasvacant) from nashville group by soldasvacant order by 2; 

select soldasvacant, case when soldasvacant = 'Y' then 'Yes'
							when  soldasvacant = 'N' then 'No'
							else soldasvacant 
							end 
from nashville; 

update nashville set soldasvacant = case when soldasvacant = 'Y' then 'Yes'
							when  soldasvacant = 'N' then 'No'
							else soldasvacant 
							end 



-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From Nashville
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress


Select *
From Nashville




-- Delete Unused Columns



Select *
From Nashville


ALTER TABLE Nashville
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate



