import 'package:flutter/material.dart';

class Auth extends StatefulWidget {
  const Auth({super.key});

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {

final _form = GlobalKey<FormState>();

var _hasAccount = false;
var _enteredEmail = '';
var _enteredPassword = '';

void _submit(){

  final isValid = _form.currentState!.validate();
  if(isValid) _form.currentState!.save();

}

  @override
  Widget build(BuildContext context) {

    

    return  Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary ,
      body: Center(
        child: SingleChildScrollView(

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(
                  top: 30, left: 20, bottom: 20, right: 20
                ),
                child: Image.asset('assets/images/chat-image.png'),
              ),
              Card(
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Email'
                            ),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            validator: (value){
                              if(value == null || value.trim().isEmpty || !value.contains('@')){
                                return 'It must be a valid email';
                              }
                              return null;
                            },
                            onSaved: (data){
                                _enteredEmail = data!;
                                print('EMAIL ===> $_enteredEmail');
                            },
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Password'
                            ),
                            obscureText: true,
                            validator: (value){
                                if(value == null || value.trim().length < 6 ){
                                  return 'Password should minimum 6 letters';
                                }
                                return null;
                            },
                            onSaved: (data){
                              _enteredPassword = data!;
                              print('PASSWORD ===> $_enteredPassword');
                            },
                          ),
                          const SizedBox(height: 20,),
                          ElevatedButton(
                            
                            onPressed: (){
                              _submit();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.primary
                            ), 
                            child: Text(_hasAccount ? 'Sign In' : 'Sign up'),
                            ),
                            TextButton(
                              onPressed: (){
                                setState(() {
                                  _hasAccount = !_hasAccount;
                                });
                              }, 
                              child:  Text(_hasAccount ? 'Create an account' : 'I already have an account')),

                      ],
                    ),),
                    
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}