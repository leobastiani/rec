@ECHO OFF
SETLOCAL EnableDelayedExpansion

call utf8

set nome=Rec
set /a i=0

cls

pushd %userprofile%\Desktop

:loop_nome
	if EXIST "!nome!.mp4" (
		set /a i=!i!+1
		set nome=Rec !i!
		goto:loop_nome
	)

echo Digite o nome do arquivo:
echo (Nomes com "android" são convertidos)
echo Default: !nome!
set /p nome2=Nome:

if ["%nome2%"] NEQ [""] (
    set nome=%nome2%
)


cls
rem agora faz o áudio

echo Áudio:
echo 0: Nenhum
echo 1: Microfone (Realtek(R) Audio)
echo 2: Mixagem estéreo (Realtek(R) Audio)
set /p audio=

if ["%audio%"] == ["1"] (
    set audio=-f dshow -channel_layout stereo -thread_queue_size 1024 -i audio="Microfone (Realtek(R) Audio)" -c:a aac -strict -2 -ac 2 -b:a 128k
    goto:after_audio
)

if ["%audio%"] == ["2"] (
    set audio=-f dshow -channel_layout stereo -thread_queue_size 1024 -i audio="Mixagem estéreo (Realtek(R) Audio)" -c:a aac -strict -2 -ac 2 -b:a 128k
    goto:after_audio
)

set audio=

:after_audio
cls

call ffmpeg -rtbufsize 200M -f gdigrab -thread_queue_size 1024 -probesize 10M -r 30 -draw_mouse 1 -i desktop !audio! -c:v libx264 -r 30 -preset ultrafast -tune zerolatency -crf 25 -pix_fmt yuv420p "!nome!.mp4"

echo x!nome:android=!

if ["!nome:android=!"] NEQ ["!nome!"] (
	call androidvideo "!nome!.mp4"
)


rem call ffmpeg -rtbufsize 200M -f gdigrab -thread_queue_size 1024 -probesize 10M -r 30 -draw_mouse 1 -i desktop -f dshow -channel_layout stereo -thread_queue_size 1024 -i audio="Mixagem estéreo (Realtek(R) Audio)" -c:v libx264 -r 30 -preset ultrafast -tune zerolatency -crf 25 -pix_fmt yuv420p -c:a aac -strict -2 -ac 2 -b:a 128k "%userprofile%\Desktop\Rec.mp4"

popd