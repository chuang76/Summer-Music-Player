# Summer-Music-Player

This repository is a final project for *Assembly Language and System Programming* in NCHU. <br>The program is under masm 32-bit mode. 

![](https://raw.githubusercontent.com/chuang76/image/master/asm2.PNG)

<br>

## Dependencies 

The repo requires following packages

- masm32

<br>

## Usage 

There are three buttons on the main window.

- `Exit to Earth` : exit and back to command line.
- `Fly to Mars` : play .wav files automatically (just like Like list on YouTube), you can press the Stop button and back to the main window.
- `Fly to Jupiter` : play the .mp3 files in your own directory.

<br>

If you want to modify the codes, you can assemble the .asm file with 

```
$ ml /c /coff /Cp final.asm
```

compile the resource file with

```
$ rc rsrc.rc
```

link the .obj files with 

```
$ link /SUBSYSTEM:WINDOWS /LIBPATH:C:\masm32\lib final.obj rsrc.res
```

and you can execute the application

```
$ final.exe
```

Hope you enjoy journey through the music ! 