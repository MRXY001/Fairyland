abstract class EditorInterface {
  void initContent(String content);

  void disableContent();

  void setText(String text, {undoable: true, pos: -1});

  String getText();

  int getPosition();

  void setPosition(int pos, {sel: 0});

  String getSelectionOrFull();

  bool hasSelection();

  int selectionStart();

  int selectionEnd();

  String selectionText();

  void setSelection(int start, int end);

  void selectAll();

  void copy();

  void cut();

  void paste();

  void clear();

  void insertTextByPos(String text, {pos: -1});

  void deleteTextByPos(int start, int end);

  void replaceTextByPos(int start, int length, String text);

  void saveToFile(String path);

  void loadFromFile(String path);

  void undo();

  void redo();

  bool canUndo();

  bool canRedo();

  void initUndoRedo();
}
