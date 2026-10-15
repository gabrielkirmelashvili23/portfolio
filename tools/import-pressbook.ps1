param([string]$Root)
$ErrorActionPreference = 'Continue'
$sb = 'https://xxeybcsrwhgslrzsvmia.supabase.co/storage/v1/object/public'
$vdir = Join-Path $Root 'public/media/videos'
$pdir = Join-Path $Root 'public/media/photos'
$bdir = Join-Path $Root 'public/media/brands'
$udir = Join-Path $Root 'public/media/uploads'
New-Item -ItemType Directory -Force $vdir, $pdir, $bdir, $udir | Out-Null

function Get-File($url, $out) {
  if (Test-Path $out) { return }
  try { Invoke-WebRequest -Uri $url -OutFile $out -UseBasicParsing -ErrorAction Stop } catch { Write-Output "FAILED $url : $($_.Exception.Message)" }
}

# Profile photo
Get-File "$sb/profile-pictures/67c79281-d365-4d80-b572-fcfc02a8878f/avatar.jpg" (Join-Path $udir 'profile.jpg')

# Brand logos
$logos = [ordered]@{
  'octobuddy.png'   = "$sb/brand-logos/custom_fbf29f18_891f_4f9e_b1b6_5d95e5bba5cb_1772994520827.png"
  'oten.webp'       = "$sb/brand-logos/custom_fbf29f18_891f_4f9e_b1b6_5d95e5bba5cb_1772994289092.webp"
  'jetech.png'      = "$sb/brand-logos/custom_67c79281_d365_4d80_b572_fcfc02a8878f_1782389983021.png"
  'uzn.jpg'         = "$sb/brand-logos/custom_fbf29f18_891f_4f9e_b1b6_5d95e5bba5cb_1772994717810.jpg"
  'zenottic.webp'   = "$sb/brand-logos/custom_fbf29f18_891f_4f9e_b1b6_5d95e5bba5cb_1772994622645.webp"
  'otake.jpg'       = "$sb/brand-logos/custom_fbf29f18_891f_4f9e_b1b6_5d95e5bba5cb_1772994367137.jpg"
  'haruharu.png'    = "$sb/brand-logos/haruharu_com_1773074720478.png"
  'dolcegabbana.png'= "$sb/brand-logos/dolcegabbana_com_1773074640567.png"
  'amboras.png'     = 'https://cdn.brandfetch.io/domain/amboras.com/theme/light/icon.png?c=1idVjY2Yi7hfdyoQ3YL'
  'mesauda.png'     = 'https://cdn.brandfetch.io/domain/mesauda.am/theme/light/icon.png?c=1idVjY2Yi7hfdyoQ3YL'
  'alfheim.png'     = 'https://cdn.brandfetch.io/domain/alfheimaromaterapi.com/theme/light/icon.png?c=1idVjY2Yi7hfdyoQ3YL'
  'dreem.png'       = 'https://cdn.brandfetch.io/domain/dreem.one/theme/light/icon.png?c=1idVjY2Yi7hfdyoQ3YL'
}
foreach ($k in $logos.Keys) { Get-File $logos[$k] (Join-Path $bdir $k) }

# Photos
$photoBase = "$sb/portfolio-photos/67c79281-d365-4d80-b572-fcfc02a8878f"
$photos = [ordered]@{
  'octobuddy-1' = '20ec6e67-5fbb-4bc7-8f3a-c4f655dcf4f2'; 'octobuddy-2' = '7d53942d-7e6a-4231-b5ec-2366ae9efc3a'
  'dreem-1' = '5cf29dc7-ab14-406c-b97c-8e82daf50f36'; 'dreem-2' = 'a35f68e6-ef4f-4425-9788-0cde7e6d0827'
  'dreem-3' = '07fe4345-174c-474f-8052-7d1f909c4e07'; 'dreem-4' = 'b84df76f-2656-48e3-a48f-8cd33c21a6ad'
  'jetech-1' = 'de02f112-d39f-458d-8876-0c31e3271825'; 'jetech-2' = 'ba1156b1-7dbd-4194-b470-a62985a7c2a2'
  'jetech-3' = '138cb8cb-0295-4ffd-8fbc-dab512176574'; 'ferris-wheel' = '0a407a1a-8360-4b0b-9c49-ec29b165b7d6'
  'camera-ledge' = 'd855d522-5519-4af0-b20b-7bf7b1ac8db3'; 'ivy-ledge' = 'e2e8df26-4397-4076-a073-c2264bdc9b38'
  'oten-1' = '1bff2d6a-da91-4c75-a382-80fa0cb8ebdd'; 'oten-2' = 'b2a9a8f5-1075-4196-be2a-1553876d7d19'
  'mesauda-1' = 'bc3feaa7-6dd5-4453-b4ff-3edb9d3e907d'; 'mesauda-2' = '599e3687-b7a9-4e9c-8294-a7bab34b3663'
  'mesauda-3' = '1772a153-6f83-4e4e-960d-8bd246400086'; 'vintage-camera' = '45af45d1-04a1-4108-a759-7d3e9b79b598'
}
foreach ($k in $photos.Keys) {
  $tmp = Join-Path $pdir "$k.orig.jpg"; $out = Join-Path $pdir "$k.webp"
  if (Test-Path $out) { continue }
  Get-File "$photoBase/$($photos[$k]).jpg" $tmp
  # Shrink to max 2000px and convert to WebP so pages load fast.
  & ffmpeg -hide_banner -loglevel error -y -i $tmp -vf "scale='min(2000,iw)':-2" -c:v libwebp -quality 82 $out
  Remove-Item $tmp -ErrorAction SilentlyContinue
}

# Videos (Mux HLS -> MP4)
$videos = [ordered]@{
  'best-performing' = 'ZnYCDQABzzajCyHpM3nxG9NgGq1iqLEI4RrEN1UqXOE'
  'amboras-1' = 'ZD8Eoz93sYOn5Xu9EyRgmtobTuWW731X2Fgzql3y3Gg'
  'amboras-2' = 'pgPAsgY01eZMNVhmxllnV1yvqRw8STGCuz3U84NwGWNg'
  'haruharu' = 'pIDcwfaUOz00UlwBuDj134gzahqQTOAUaeYkGo2f5uOQ'
  'dolce-gabbana' = 'BVcwgQIn6PLtP55KYGzquyySqmf5DAzYfRWqARARMGY'
  'alfheim' = 'zki8o4E8hJM38ST4CAymc4x2DcXUV71nmQWxbRWcKW8'
  'zenottic' = 'tnxxrE9ZGRUpfQ4SecBA6hMiPTx5hL01xIuHpye7qQ01g'
  'otake' = 'T9odtQ1peXng1lt5oYtZ02JG8JeGHfK3UomdyNT200On4'
  'dreem' = '2Lx4h202Ec1HZW5z3ydX019Iow9FYY00dz00Wox9E01y79ds'
  'jetech' = 'gJSjTKLKwtmEX8d6ZZUnfNn4jkQzLY1CLRpXVU1Exls'
}
foreach ($k in $videos.Keys) {
  $out = Join-Path $vdir "$k.mp4"
  if (-not (Test-Path $out)) {
    & ffmpeg -hide_banner -loglevel error -y -i "https://stream.mux.com/$($videos[$k]).m3u8" -c copy -bsf:a aac_adtstoasc -movflags +faststart $out
  }
  # Cloudflare Pages allows 25 MB per file: re-encode anything bigger.
  if ((Test-Path $out) -and (Get-Item $out).Length -gt 24MB) {
    $small = Join-Path $vdir "$k.small.mp4"
    & ffmpeg -hide_banner -loglevel error -y -i $out -c:v libx264 -crf 24 -preset slow -vf "scale='min(1080,iw)':-2" -c:a aac -b:a 128k -movflags +faststart $small
    Move-Item -Force $small $out
  }
  $poster = Join-Path $vdir "$k.jpg"
  if ((Test-Path $out) -and -not (Test-Path $poster)) {
    & ffmpeg -hide_banner -loglevel error -y -ss 1 -i $out -frames:v 1 -vf "scale='min(720,iw)':-2" -q:v 4 $poster
  }
}

Get-ChildItem $udir, $bdir, $pdir, $vdir | Select-Object @{n='File';e={$_.FullName.Replace($Root,'')}}, @{n='KB';e={[math]::Round($_.Length/1KB)}} | Format-Table -AutoSize | Out-String -Width 200
