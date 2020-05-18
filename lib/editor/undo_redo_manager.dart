import 'package:flutter/material.dart';

/// 撤销重做原子操作
class EditOperator {
  // 删除操作
  String src;
  int srcStart;
  int srcEnd;

  // 输入操作
  String dst;
  int dstStart;
  int dstEnd;

  EditOperator(
      {this.src,
      this.srcStart,
      this.srcEnd,
      this.dst,
      this.dstStart,
      this.dstEnd});

  bool isInput() => src==null && dst!=null;
  
  void undo(TextEditingController controller) {
    String text = controller.text;

    int idx = -1;
    // 删除输入内容
    if (dstEnd != null && dstEnd > 0) {
//      print('delete input: ' + dst);
      text = text.substring(0, dstStart) + text.substring(dstEnd);
      if (src == null) {
        idx = dstStart;
      }
    }
    // 插入删掉内容
    if (src != null) {
//      print('insert delete: ' + src);
      text = text.substring(0, srcStart) + src + text.substring(srcStart);
    }

    controller.text = text;
    // 恢复光标位置
    if (idx >= 0) {
      controller.selection =
          TextSelection.fromPosition(TextPosition(offset: idx));
    }
  }

  void redo(TextEditingController controller) {
    String text = controller.text;

    int idx = -1;
    // 删除输入内容
    if (srcEnd != null && srcEnd > 0) {
//      print('delete delete: ' + src);
      text = text.substring(0, srcStart) + text.substring(srcEnd);
      if (dst == null) {
        idx = srcStart;
      }
    }
    // 插入输入内容
    if (dst != null) {
//      print('insert insert: ' + dst);
      text = text.substring(0, dstStart) + dst + text.substring(dstStart);
      idx = dstStart + dst.length;
    }

    controller.text = text;
    // 恢复光标位置
    if (idx >= 0) {
      controller.selection =
          TextSelection.fromPosition(TextPosition(offset: idx));
    }
  }
}

/// 撤销重做管理器
/// 统一进行撤销、重做操作
class OperatorManager {
  bool _enable = true;
  final List<EditOperator> undoOpts = [];
  final List<EditOperator> redoOpts = [];
  String preText; // 上一次变化的文本
  int preLength; // 上一次的文本长度
  int preStart; // 上一次变化的光标位置
  int preEnd; // 上一次变化的选中位置。如果是-1，则表示没有选中

  OperatorManager enable() {
    _enable = true;
    return this;
  }

  OperatorManager disable() {
    _enable = false;
    return this;
  }

  bool canUndo() {
    return undoOpts.length > 0;
  }

  bool canRedo() {
    return redoOpts.length > 0;
  }

  void clearUndoRedo() {
    undoOpts.clear();
    redoOpts.clear();
    preText = null;
    preStart = null;
    preEnd = null;
    _enable = false;
  }

  void initUndoRedo(TextEditingController controller) {
    preText = controller.text;
    preLength = preText.length;
    preStart = controller.selection.start;
    preEnd = controller.selection.end;
  }

  EditOperator onTextChanged(TextEditingController controller) {
    if (!_enable) {
      // 可能是在撤销的时候
      return null;
    }
    String text = controller.text;
    int length = text.length;
    int start = controller.selection.start;
    int end = controller.selection.end;
//    print('selection: ' + start.toString() + ' ' + end.toString());
    // 保存记录
    if (length == preLength && preEnd == preStart) {
      // 一样长，可能是选中后输入
      preStart = start;
      preEnd = end;
//      print('---------------------same-----------------');
      return null;
    } else if (preEnd > -1 && preEnd != preStart) {
      // 选中内容的替换
      if (preText == text) {
        // 文本没改变，只是选择的内容改变了
//        print('-----------------selection changed--------------');
      } else if (end == start && start >= preStart) {
//        print('---------------------selection replace---------------');
        String src = preText.substring(preStart, preEnd);
        String dst = text.substring(preStart, start);
//        print(src + '  ' + preStart.toString() + '~' + preEnd.toString());
//        print(dst + '  ' + start.toString() + '~' + end.toString());
        undoOpts.add(EditOperator(
            src: src,
            srcStart: preStart,
            srcEnd: preEnd,
            dst: dst,
            dstStart: start - dst.length,
            dstEnd: start));
        redoOpts.clear();
      } else {
//        print('------------------unknow selection replace----------------');
      }
    } else if (length > preLength) {
      // 输入新内容；也可能是选中后替换为新内容
//      print('---------------------insert-----------------');
      int delta = length - preLength;
      preStart = start - delta;
      String src = text.substring(preStart, start);
      undoOpts.add(EditOperator(dst: src, dstStart: preStart, dstEnd: start));
//      print(src + '  ' + preStart.toString() + '~' + start.toString());
      redoOpts.clear();
    } else {
      // 变短，比如是删除一部分
//      print('---------------------delete-----------------');
      int delta = preLength - length;
      preStart = start;
      preEnd = start + delta;
//      print('delete: ' + preStart.toString() + ' ' + preEnd.toString());
      String dst = preText.substring(preStart, preEnd);
      undoOpts.add(EditOperator(src: dst, srcStart: preStart, srcEnd: preEnd));
//      print(dst + '  ' + preStart.toString() + '~' + preEnd.toString());
      redoOpts.clear();
    }

    // 保存至下一次使用
    preText = text;
    preLength = length;
    preStart = start;
    preEnd = end;
    
    return undoOpts.last;
  }

  bool undo(TextEditingController controller) {
    if (canUndo()) {
      EditOperator opt = undoOpts.removeLast();
      disable();
      opt.undo(controller);
      enable();
      initUndoRedo(controller);
      redoOpts.add(opt);
      return true;
    }
    return false;
  }

  bool redo(TextEditingController controller) {
    if (canRedo()) {
      EditOperator opt = redoOpts.removeLast();
      disable();
      opt.redo(controller);
      enable();
      initUndoRedo(controller);
      undoOpts.add(opt);
      return true;
    }
    return false;
  }
}
