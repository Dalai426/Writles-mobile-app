Future<bool> checkTextNull(String text) async {

  if(text.isEmpty){
    return true;
  }

  String replacedText = text.replaceAll(RegExp(r'\s+'), '');
  if(replacedText.isEmpty){
    return true;
  }

  return false;
}
