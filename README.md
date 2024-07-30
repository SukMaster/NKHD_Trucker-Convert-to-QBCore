# NKHD_Trucker
This script is created by Niknock HD
https://github.com/Niknock/NKHD_Trucker

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

## Lisensi
MIT License
Copyright (c) 2024 Niknock HD
Copyright (c) 2024 SukMaster

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
