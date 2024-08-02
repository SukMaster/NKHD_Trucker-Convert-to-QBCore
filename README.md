# NKHD_Trucker
This script is created by Niknock HD
https://github.com/Niknock/NKHD_Trucker

preview : https://youtu.be/FZJlREEHa6M?si=r49lhTlo6guk5X97

# NKHD_Trucker Konversi ke QBCore
This script was converted by SukMaster
Jika butuh bantuan bisa gabung discord saya : https://discord.gg/vwNCqnc5xJ

## Kontributor
- Niknock HD
- SukMaster

## Deskripsi
Skrip ini merupakan konversi dari ESX ke QBCore. Skrip ini menambahkan fitur pekerjaan baru ke dalam server QBCore Anda.

## qb-core/client/functions.lua
## letakan kode ini di paling bawah
QBCore.Functions.ShowHelpNotification = function(message)
    SetTextComponentFormat('STRING')
    AddTextComponentString(message)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

### Dependensi
https://github.com/SukMaster/progressBars
