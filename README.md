# Arashi

## 概要  
   
これはフレームワークを作成するにあたってのサンプル作ったプロジェクトです。   
フレームワークを作成することが目的の為、実際に使用するにあたっての利便性などについては全く考慮していませんが、   
一応使い方を記載しておきますので、ご参照ください。   
Exampleも入れてあります。   
普通に使う場合はプロジェクトからArashi.swiftをプロジェクトにコピーして使用してください。   
  
## 機能 
  
キーボードを表示する際に隠れてしまう分の高さをDelegateで通知するだけのものです。  
ちなみに、このキーボードとViewの差分については、Viewの指定を1度に1つしか指定できないので、全くを持って使い勝手が悪いです。あしからず。  
 
 
## 環境 
Xcode 10.2 以上  
Swift4.2 以上  
 
## 使い方  
  
1. プロジェクトをローカルにダウンロードします。  
2. ターゲットをArashi-UniversalのGeneric iOS Deviceに切り替えてビルドします。  
3. プロジェクトファイルと同階層に.frameworkが作成されるので、使いたいプロジェクトでEmbedします。  
4. 使いたいファイルで import Arashi を記述して以下のように使用します。  
  
プロパティにArashiを定義します。  
  
```swift
var arashi: Arashi?
```
  
初期化します。  
初期化時に、第1引数に一番親のViewを、第2引数に差分を取得したい対象のViewを設定し、delegateに自身のViewControllerを指定します。  
 
```swift
arashi = Arashi(parentView: view, targetView: innerTextView, delegate: self)
```
  
あとはdeleateを実装します。 
  
```swift
    extension ViewController: ArashiDelegate {
    func arashiKeyboardWillShow(notification: Notification, diff: CGFloat?) {
        if let diff = diff {
            innerTextViewTop.constant -= diff
            UIView.animate(withDuration: 1, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    func arashiKeyboardDidShow(notification: Notification, diff: CGFloat?) {
    }
    func arashiKeyboardWillHide(notification: Notification) {
        innerTextViewTop.constant = 8
        UIView.animate(withDuration: 1, animations: {
            self.view.layoutIfNeeded()
        })
    }
    func arashiKeyboardDidHide(notification: Notification) {
    }
}
```


