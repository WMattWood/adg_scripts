# adg_scripts
Ableton Live saves device racks as **.adg** files.  These sometimes reference audio  
samples, and re-mapping the references manually within Ableton Live can be time  
consuming.  This set of scripts allows unpacking the .adg so you can view and  
edit the internal .xml file in a text editor.

The `backpack.sh` script allows painless remapping to a local folder, assuming  
a flat file hierarchy.  The file structure must be as follows

```
My Devices Folder/
├── Drum Rack.adg
└── drum_samples/
    ├── kick.wav
    ├── snare.wav
    ├── hihat.wav
    └── clap.wav
```

In this example, you could call `./backpack.sh "Drum Rack.adg" "drum_samples"`    
and all samples referenced in the Drum Rack will now be expected to be found   
in the `drum_samples` folder.  The script will create a copy of the original  
.adg file with a **_patched** suffix.

## backpack.sh 
Usage: `./backpack.sh "Super 909 Kit.adg" "909 Drums"`  
Fully automates unpack → smart flatten SampleRef paths → repack

## unpack_adg.sh
Usage: `./unpack_adg.sh "Super 909 Kit.adg"`  
Copies, renames, and unzips an Ableton .adg into an editable .xml

## repack_adg.sh
Usage: `./repack_adg.sh "Super 909 Kit.xml"`  
Compresses the edited .xml back into a valid Ableton .adg