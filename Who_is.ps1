
Write-Output "`n--- Ce script fait un ping de la machine et renvoi le NNI de l'utilisateur qui l'utilise V03_RC ---`n"
$TargetComputer = Read-Host "Entrez le DSP ou l'adresse IP de l'ordinateur "

Write-Output "`nping $TargetComputer ..."
if (Test-Connection -ComputerName $TargetComputer -Count 1 -Quiet) {
    Write-Output "$TargetComputer est en ligne.`n"

    try {
        $LoggedUsers = Get-WmiObject -Class Win32_ComputerSystem -ComputerName $TargetComputer
        if ($LoggedUsers.UserName) {
            $LoggedUser = $LoggedUsers.UserName
            Write-Output "L'utilisateur actuellement sur $TargetComputer est $LoggedUser `n"
			Write-Output "Voulez-vous obtenir la clef bitlocker du poste (Oui/Non) ?"
			$response = Read-Host
			$response = $response.ToLower()
			if ($response -in "oui", "o", "yes", "y") {
			manage-bde -computername $TargetComputer -protectors -get c:
			
			Write-Output "Voulez-vous verouiller Bitlocker sur ce poste Taper : Oui (Oui/Non) ? `n Cette action va redemarer le poste"
			$response2 = Read-Host
			if ($response2 -in "Oui"){
					
					Write-Output "Inserer ici la commande de suppression safe mode `n"
					manage-bde -computername $TargetComputer -forcerecovery c:
					Stop-Computer -Force -computername $TargetComputer 
					# Restart-Computer -Force -computername $TargetComputer 
					} else { Write-Output "Fin du script . `n" }
			
			
				} else { Write-Output "Fin du script . `n" }
				
        } else {
            Write-Output "Aucun utilisateur sur $TargetComputer . `n"
        }
    }
    catch {
        Write-Host "Une erreur est survenue lors de l'interrogation de $TargetComputer : $_ "
    }
} else {
    Write-Output "Impossible de joindre $TargetComputer. Le poste n'est pas en ligne. `n"
}
