import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class BookFields extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BookFields();
  }
}

class _BookFields extends State<BookFields> {
  final formKey = GlobalKey<FormState>();
  bool isAutoValidate = false;
  var coverPath;
  var name;
  var type;
  var author;
  bool isChanged = false;
  bool isModified = false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(title: Text('创建作品')),
        body: ListView(
          children: <Widget>[
            Card(
              clipBehavior: Clip.antiAlias,
              color: Theme.of(context).backgroundColor,
              elevation: 16,
              margin: EdgeInsets.all(16),
              semanticContainer: true,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: createForm(),
              ),
            ),
          ],
        ));
  }

  Widget createForm() {
    return Form(
      key: formKey,
      autovalidate: isAutoValidate,
      //      onWillPop: willPop,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          GestureDetector(
            onTap: () => selectCover(),
            child: getCoverImage(coverPath),
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: '书名 *'),
            keyboardType: TextInputType.text,
            validator: (value) {
              value = value.trim();
              if (value.isEmpty) {
                return '请输入作品名字';
              } else {
                Pattern pattern = r'^[\w\d@\-\._:?！ \u4e00-\u9fa5]+$';
                RegExp regex = new RegExp(pattern);
                if (!regex.hasMatch(value)) return '请输入正确的书名格式';
              }
              return null;
            },
            onSaved: (value) => name = value,
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: '风格'),
            keyboardType: TextInputType.text,
            onSaved: (value) => type = value,
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: '作者'),
            keyboardType: TextInputType.text,
            onSaved: (value) => author = value,
          ),
          SizedBox(height: 10),
          FlatButton(
            onPressed: validateInputs,
            child: Text('创建'),
          )
        ],
      ),
    );
  }
  
  Widget getCoverImage(var path)
  {
    if (path == null)
      return new Image.asset('assets/covers/default.png');
    return new Image.file(path);
  }

  void validateInputs() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
    } else {
      // 输入后再开启自动检查
      setState(() => isAutoValidate = true);
    }
  }

  /// 退出前是否提示
  Future<bool> willPop() {
    // 直接 pop 会导致返回的时候出错
    /*if (!isChanged) {
      Navigator.pop(context, true);
      return Future.value(true);
    }*/
    return showDialog(
          builder: (context) => AlertDialog(
            title: Text('您有修改未保存，确定退出当前页？'),
            actions: <Widget>[
              FlatButton(
                child: Text('No'),
                onPressed: () => Navigator.pop(context, false),
              ),
              FlatButton(
                child: Text('Yes'),
                onPressed: () => Navigator.pop(context, true),
              ),
            ],
          ),
          context: context,
        ) ??
        false;
  }
  
  void selectCover() async
  {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    print('========image========');
    print(image);
    setState(() {
      coverPath = image;
    });
  }
}
