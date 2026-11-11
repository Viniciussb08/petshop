# =========================================================
#  PataViva - Servidor local (PowerShell / sem dependencias)
#  Uso: duplo clique em servir.bat  ou  execute este arquivo
#  Para parar: Ctrl + C nesta janela
# =========================================================
param(
  [int]$Port = 8080,
  [switch]$NoBrowser
)

$ErrorActionPreference = "Stop"

$Root = $PSScriptRoot
if ([string]::IsNullOrWhiteSpace($Root)) { $Root = (Get-Location).Path }
$RootFull = [System.IO.Path]::GetFullPath($Root).TrimEnd('\')

$mimeMap = @{
  ".html"  = "text/html; charset=utf-8"
  ".htm"   = "text/html; charset=utf-8"
  ".css"   = "text/css; charset=utf-8"
  ".js"    = "application/javascript; charset=utf-8"
  ".json"  = "application/json; charset=utf-8"
  ".map"   = "application/json; charset=utf-8"
  ".jpg"   = "image/jpeg"
  ".jpeg"  = "image/jpeg"
  ".png"   = "image/png"
  ".webp"  = "image/webp"
  ".gif"   = "image/gif"
  ".svg"   = "image/svg+xml"
  ".ico"   = "image/x-icon"
  ".woff2" = "font/woff2"
  ".woff"  = "font/woff"
  ".ttf"   = "font/ttf"
  ".txt"   = "text/plain; charset=utf-8"
  ".xml"   = "application/xml; charset=utf-8"
  ".pdf"   = "application/pdf"
  ".mp4"   = "video/mp4"
}

function New-LocalListener {
  param([int]$Porta)
  $l = New-Object System.Net.HttpListener
  $l.Prefixes.Add("http://localhost:$Porta/")
  $l.Start()
  return $l
}

# --- Escolhe uma porta livre (tenta 8080, 8081, 8082...) ---
$listener = $null
$portaAtual = $Port
for ($i = 0; $i -lt 10; $i++) {
  try {
    $listener = New-LocalListener -Porta $portaAtual
    break
  } catch {
    $portaAtual = $Port + $i + 1
  }
}

if (-not $listener) {
  Write-Host ""
  Write-Host "  Nao foi possivel iniciar o servidor nas portas $Port a $($Port + 9)." -ForegroundColor Red
  Write-Host "  Feche outros servidores e tente novamente." -ForegroundColor Red
  Write-Host ""
  exit 1
}

$url = "http://localhost:$portaAtual/"

Write-Host ""
Write-Host "  ============================================" -ForegroundColor DarkGray
Write-Host "   PataViva - Servidor local ativo" -ForegroundColor Green
Write-Host "  ============================================" -ForegroundColor DarkGray
Write-Host "   Pasta : $RootFull"
Write-Host "   URL   : " -NoNewline; Write-Host $url -ForegroundColor Cyan
Write-Host ""
Write-Host "   Pressione Ctrl + C para encerrar." -ForegroundColor Yellow
Write-Host ""

if (-not $NoBrowser) {
  Start-Process $url | Out-Null
}

while ($listener.IsListening) {
  try {
    $ctx = $listener.GetContext()
    $req = $ctx.Request
    $res = $ctx.Response

    $relative = [System.Uri]::UnescapeDataString($req.Url.LocalPath).TrimStart('/')
    if ([string]::IsNullOrWhiteSpace($relative)) { $relative = "index.html" }
    $relative = $relative -replace '/', '\'

    $full = [System.IO.Path]::GetFullPath((Join-Path $RootFull $relative))

    # Seguranca: impede acesso fora da pasta do projeto
    if (-not $full.StartsWith($RootFull, [System.StringComparison]::OrdinalIgnoreCase)) {
      $res.StatusCode = 403
      $msg = [System.Text.Encoding]::UTF8.GetBytes("403 - Acesso negado")
      $res.ContentType = "text/plain; charset=utf-8"
      $res.OutputStream.Write($msg, 0, $msg.Length)
      $res.OutputStream.Close()
      continue
    }

    # Diretorio -> index.html
    if (Test-Path -LiteralPath $full -PathType Container) {
      $full = Join-Path $full "index.html"
    }

    if (Test-Path -LiteralPath $full -PathType Leaf) {
      $bytes = [System.IO.File]::ReadAllBytes($full)
      $ext = [System.IO.Path]::GetExtension($full).ToLowerInvariant()
      $res.ContentType = if ($mimeMap.ContainsKey($ext)) { $mimeMap[$ext] } else { "application/octet-stream" }
      $res.Headers["Cache-Control"] = "no-store, no-cache, must-revalidate"
      $res.ContentLength64 = $bytes.Length
      $res.OutputStream.Write($bytes, 0, $bytes.Length)
      Write-Host ("  200  " + $req.HttpMethod + "  " + $relative) -ForegroundColor DarkGray
    } else {
      $res.StatusCode = 404
      $msg = [System.Text.Encoding]::UTF8.GetBytes("404 - Nao encontrado: $relative")
      $res.ContentType = "text/plain; charset=utf-8"
      $res.OutputStream.Write($msg, 0, $msg.Length)
      Write-Host ("  404  " + $req.HttpMethod + "  " + $relative) -ForegroundColor DarkYellow
    }

    $res.OutputStream.Close()
  } catch {
    # Cliente cancelou a conexao: segue o jogo
    Write-Host ("  aviso: " + $_.Exception.Message) -ForegroundColor DarkYellow
  }
}
