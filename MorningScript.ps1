#$Assign Variables
$ADRoot = (Get-ADDomain).DistinguishedName
$DnsRoot = (Get-ADDomain).DNSRoot
$OUCanonicalName = "Finance"
$OUDisplayName = "Finance Department"
$ADPath = "OU=$($OUCanonicalName),$($ADRoot)"

# Creating OU
try 
{
    # Checks before creating OU 
    $existingOU = Get-ADOrganizationalUnit -Filter "Name -like 'Finance'"
    if ($existingOU) {
        Write-Host -ForegroundColor Green "[AD]$($OUCanonicalName) Already Exists"
        Remove-ADOrganizationalUnit -Identity $ADPath -Recursive -confirm:$False
        Write-Host -ForegroundColor Green "[AD]$($OUCanonicalName) OU Deleted"
        Write-Host -ForegroundColor Green "[AD]$($OUCanonicalName) Creating new OU"
        New-ADOrganizationalUnit -Path $ADRoot -Name $OUCanonicalName -DisplayName $OUDisplayName -ProtectedFromAccidentalDeletion $False
        Write-Host -ForegroundColor Green "[AD]$($OUCanonicalName) OU Created"
    } else {
        Write-Host -ForegroundColor Green "[AD]:$($OUCanonicalName) does not exist" 
        New-ADOrganizationalUnit -Path $ADRoot -Name $OUCanonicalName -DisplayName $OUDisplayName -ProtectedFromAccidentalDeletion $False
        Write-Host -ForegroundColor Green "[AD]:$($OUCanonicalName) OU created" 
    } 
}
catch {
    Write-Host -ForegroundColor Red "An Error Occured"
}

# Adding Active Directory Users from a CSV File
$NewADUsers = Import-Csv -Path C:\Source\Requirements2\financePersonnel.csv
try
{
    ForEach ($ADUser in $NewADUsers)
    {
        $First = $ADUser.First_Name
        $Last = $ADUser.Last_Name
        $Name = $First + " " + $Last
        $Postal = $ADUser.PostalCode
        $Office = $ADUser.OfficePhone
        $Mobile = $ADUser.MobilePhone
        
        New-ADUser -GivenName $First -Surname $Last -Name $Name -DisplayName $Name -PostalCode $Postal -MobilePhone $Mobile -OfficePhone $Office -Path $ADPath }
        Write-Host -ForegroundColor Green "[AD]: Active Directory Tasks Complete" 
}
# Catch block for error handling
catch
{
    Write-Host -ForegroundColor Red "An Error Occured" 
}  

#Output file
Get-ADUser -Filter * -SearchBase "ou=Finance,dc=consultingfirm,dc=com" -Properties DisplayName,PostalCode,OfficePhone,MobilePhone | Out-File -FilePath C:\Source\Requirements2\AdResults.txt
