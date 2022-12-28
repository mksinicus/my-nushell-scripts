#!/usr/bin/env nu

input -s "Press enter to upgrade apt:"
sudo apt upgrade
input -s "Press enter to refresh snap:"
snap refresh
echo "Your softwares are latest. Have a nice day!"
