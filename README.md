# Music Player with MASM

The purpose of this project is to construct a music player in the assembly language. All of the programs are under masm 32-bit mode. 

<img src="https://raw.githubusercontent.com/chuang76/image/master/asm3.PNG" width="600">



## Dependency 

If you want to modify the codes, the following package is required

- masm32

  


## Usage 

There are three buttons in the main window as follows. 

- Exit to Earth: exit and back to the command line
- Fly to Mars: play audio files in wav format automatically (like Favorite list on YouTube), you can press the Stop button and back to the main window
- Fly to Jupiter: play the mp3 files in your own directory


If you want to modify the codes, you can assemble the source programs (.asm) with 

```
$ ml /c /coff /Cp final.asm
```

compile the resource files 

```
$ rc rsrc.rc
```

link the object files 

```
$ link /SUBSYSTEM:WINDOWS /LIBPATH:C:\masm32\lib final.obj rsrc.res
```

or you can just run the executable

```
$ final.exe
```
