import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_file_manager/flutter_file_manager.dart';
import 'package:path_provider_ex/path_provider_ex.dart';
import 'package:permission_handler/permission_handler.dart';
//import package files


//apply this class on home: attribute at MaterialApp()
class MyFileList extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _MyFileList();
  }
}

class _MyFileList extends State<MyFileList>{
  var files;

  // void initState(){
  //   super.initState();

   
  // }


  Future<void>  handlerpermssion() async {
    var permission =await  Permission.storage;

    if(permission.status==PermissionStatus.granted){
      print("Permsiion");
      
    }
    else{
      await Permission.storage.request();

   

    
      getFiles() ;
  

      
    }


  }
 
  void getFiles() async { //asyn function to get list of files
      List<StorageInfo> storageInfo = await PathProviderEx.getStorageInfo();
      var root = storageInfo[0].rootDir; //storageInfo[1] for SD card, geting the root directory
      var fm = FileManager(root: Directory(root)); //
      files = await fm.filesTree( 
      //set fm.dirsTree() for directory/folder tree list
        excludedPaths: ["/storage/emulated/0/Android"],
        extensions: ["png", "pdf","docx"] //optional, to filter files, remove to list all,
        //remove this if your are grabbing folder list
      );
      print(files);
      setState(() {}); //update the UI
  }

  @override
  void initState() {
     //call getFiles() function on initial state. 
    super.initState();
     handlerpermssion();
   
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title:Text("File/Folder list from SD Card"),
          backgroundColor: Colors.redAccent
        ),
        body:files == null? Text("Searching Files"):
             ListView.builder(  //if file/folder list is grabbed, then show here
                itemCount: files?.length ?? 0,
                itemBuilder: (context, index) {
                      return Card(
                        child:ListTile(
                           title: Text(files[index].path.split('/').last),
                           leading: Icon(Icons.image),
                           trailing: Icon(Icons.delete, color: Colors.redAccent,),
                        )
                      );
                },
            )
      ),
    );
  }
}