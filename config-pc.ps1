# ============================================================
# CONFIGURAÇÃO DO WINDOWS + GOOGLE CHROME - EMPRESA
# Desenvolvido por: Oséias Alves-TI
# ============================================================

Write-Host "==============================================" -ForegroundColor Cyan
Write-Host " CONFIGURACAO DO COMPUTADOR - EMPRESA" -ForegroundColor Cyan
Write-Host "==============================================" -ForegroundColor Cyan

# ============================================================
# 1 - CONFIGURAR FUSO HORARIO DE BRASILIA
# ============================================================

Write-Host "`nConfigurando fuso horario de Brasilia..." -ForegroundColor Yellow

Set-TimeZone -Id "E. South America Standard Time"

Write-Host "Fuso horario: Brasilia" -ForegroundColor Green

# ============================================================
# 2 - SINCRONIZAR DATA E HORA
# ============================================================

Write-Host "Sincronizando data e hora..." -ForegroundColor Yellow

# Configura servidor de horario
w32tm /config /manualpeerlist:"pool.ntp.org" /syncfromflags:manual /update

# Reinicia servico de horario
Restart-Service W32Time -Force

# Forca sincronizacao
w32tm /resync

Write-Host "Horario sincronizado." -ForegroundColor Green

# ============================================================
# 3 - CONFIGURAR GOOGLE CHROME VIA POLITICAS
# ============================================================

Write-Host "`nConfigurando Google Chrome..." -ForegroundColor Yellow

$ChromePolicy = "HKLM:\SOFTWARE\Policies\Google\Chrome"

# Cria a chave principal caso nao exista
if (!(Test-Path $ChromePolicy)) {
    New-Item -Path $ChromePolicy -Force | Out-Null
}

# --- A) PAGINA INICIAL E BOTÃO HOME ---
New-ItemProperty -Path $ChromePolicy -Name "HomepageLocation" -PropertyType String -Value "http://serv-web/portal/" -Force | Out-Null
New-ItemProperty -Path $ChromePolicy -Name "HomepageIsNewTabPage" -PropertyType DWord -Value 0 -Force | Out-Null

# Ativa exibição do Botao Home (Casinha)
New-ItemProperty -Path $ChromePolicy -Name "ShowHomeButton" -PropertyType DWord -Value 1 -Force | Out-Null

# Abrir portal ao iniciar
New-Item -Path "$ChromePolicy\RestoreOnStartupURLs" -Force | Out-Null
New-ItemProperty -Path "$ChromePolicy\RestoreOnStartupURLs" -Name "1" -PropertyType String -Value "http://serv-web/portal/" -Force | Out-Null
New-ItemProperty -Path $ChromePolicy -Name "RestoreOnStartup" -PropertyType DWord -Value 4 -Force | Out-Null

# --- B) FAVORITOS DA EMPRESA E BARRA DE FAVORITOS ---
# Forca a exibição da Barra de Favoritos
New-ItemProperty -Path $ChromePolicy -Name "BookmarkBarEnabled" -PropertyType DWord -Value 1 -Force | Out-Null

# Adiciona pasta com o portal da empresa nos favoritos
$BookmarksJson = '[{"toplevel_name": "Empresa"}, {"name": "Portal da Empresa", "url": "http://serv-web/portal/"}]'
New-ItemProperty -Path $ChromePolicy -Name "ManagedBookmarks" -PropertyType String -Value $BookmarksJson -Force | Out-Null

# --- C) MODO ESCURO NO SISTEMA E CHROME ---
# Força o Modo Escuro no Windows Apps/Chrome
$ThemePath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize"
if (Test-Path $ThemePath) {
    Set-ItemProperty -Path $ThemePath -Name "AppsUseLightTheme" -Value 0 -Force | Out-Null
}

Write-Host "Chrome configurado com sucesso!" -ForegroundColor Green

# ============================================================
# FINAL
# ============================================================

Write-Host "`n==============================================" -ForegroundColor Cyan
Write-Host " CONFIGURACAO CONCLUIDA!" -ForegroundColor Green
Write-Host " Responsavel: Oseias Alves-TI" -ForegroundColor Yellow
Write-Host "==============================================" -ForegroundColor Cyan

Write-Host "`nFuso: Brasilia"
Write-Host "Sincronizacao: Ativada"
Write-Host "Portal: http://serv-web/portal/"
Write-Host "Chrome: Icone Home | Favoritos | Modo Escuro"
Write-Host "`nScript executado por: Oseias Alves-TI" -ForegroundColor DarkGray
Write-Host "`nPressione qualquer tecla para fechar..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
