#include <Servo.h>

String textoRecebido = ""; // initilizing of command string
unsigned long delay1 = 0; // unsigned long: stores bigger variables, 32 bits (4 bytes), doesn't work with negative numbers

//Servo pins
#define pinBase 11 // define: define a constant and pinBase: digital port
#define pinArt 12
#define pinGarra 10

//Servo assingment
Servo Base;
Servo Art;
Servo Garra;

int Buzzer = 7; // digital port that'll be connected to the buzzer

//Phase verification
int led[2] = {8,9}; // LEDs for the auto and manual phases - led[2] is a vectorand uses digital ports 8 and 9 (being a vector, simplifies the code)
int pinBotao = 4;
int pinBotaoSair = 2;
int i;
int fase = 0; // phase counter
int estadoAnteriorBotao;

// Manual

// potenciometers to control the base, joint and claw
float potGarra;
float potBase;
float potArt;

// variables that'll recieve the servos' outputs (angular position)
int AngBase;
int AngArt;
int AngGarra;

void setup() { // void because nothing is returned. Setup: runs once and is used throughout the program as a whole
Serial.begin(9600); // opening of the serial communication channel (arduino and serial monitor). 9600: communication rate (times/second)
                    
  for(i = 0; i < 2; i++){
    pinMode(led[i],OUTPUT); // defines the LED pins as energy output (5V)
  }

 // Define the buttons pins as input (5V)
  pinMode(pinBotao,INPUT);
  pinMode(pinBotaoSair,INPUT);
  
   estadoAnteriorBotao = digitalRead(pinBotao); // assingns the button's initial value (HIGH or LOW) to the estadoAnteriorBotao variable
   
  pinMode(Buzzer, OUTPUT); // defines the buzzer pin as output (5V)

// tells the arduino which pins the servos are connected on
  Base.attach(pinBase);
  Art.attach(pinArt);
  Garra.attach(pinGarra);
}

void loop() { // loops the routine

  // Time variables (delay)
  int tempomov = 3000; // between movement
  int tempobuzzer = 500; // buzzer on
  int pausadramatica = 1000; // after grabbing object
  int tempoinvalido = 200; // buzzer on for when invalid options are typed
  
  // Reading variables
  char caracter; // counter to generate the string
  int estadoBotao; // stores button state (HIGH or LOW)
  int Sair; // stores Exit button state (HIGH or LOW)

    estadoBotao = digitalRead(pinBotao); // after being pressed, its value is assinged to the estadoBotao variable

  /* Phase counting (when the button is released, the fase variable is increased or reset, depending on the state.
     This is done only when the button is released because the program runs 9600 times/second */
   if ((estadoBotao == LOW) && (estadoAnteriorBotao == HIGH)) { // counts the phase and guaranteesthat it'll increase only once
     
     if (fase < 2) {
       fase = fase + 1;
     } else {
       fase = 0;
     }  
  }
   estadoAnteriorBotao = estadoBotao; // estadoAnteriorBotao recieves estadoBotao's value, allowing the phase to be chosen
  
// Automatic phase
if(fase == 1){
     digitalWrite(led[0], HIGH); // digitalWrite: sends energy to the port connectec to the automatic phase's LED

     if (Serial.available()) {    // evaluates if any command was typed in the serial monitor. This data goes to the serial buffer
     caracter = Serial.read();
     textoRecebido += caracter; // caracter is a counter that concatenates each character to generate a word
     delay1 = millis(); //delay1 recieves the time of execution of this command block
     }

     if (((millis() - delay1) > 10) && (textoRecebido != "")) { /* The program runtime must be greater than the reading time of textoRecebido (> 10 ms)
                                                                  because it's looping. Time is adjusted according to the tests execution */ 
     Serial.print("Comando: ");
     Serial.println(textoRecebido); //prints the string recieved

  

             if(textoRecebido == "Esquerda"){
              
             // Move to the object on the left
             do{
             Garra.write(37); // angular position
             delay(tempomov);
             Base.write(110);
             delay(tempomov);
             Garra.write(111);
             delay(tempomov);
             Art.write(170);
             delay(tempomov);
             Garra.write(37);
             delay(pausadramatica);
       
             // Take object to drop zone
             Art.write(21);
             delay(tempomov);
             Base.write(60);
             delay(tempomov);
             Art.write(170);
             delay(tempomov);
             Garra.write(111);
             delay(tempomov);
             Art.write(21);
             digitalWrite(Buzzer, HIGH);
             delay(tempobuzzer);
             digitalWrite(Buzzer, LOW); 
             
             
             Sair = digitalRead(pinBotaoSair);
             }while(Sair == LOW); // while the Sair button isn't pressed, the program continues executing the selected function
             textoRecebido = "Fim";
             Serial.println(textoRecebido); // when the button is pressed, the program will print "Fim" on the serial monitor and will exit the function
             }
    
             if(textoRecebido == "Direita"){
             
             // Move to the object on the right
             do{
             Garra.write(37);
             delay(tempomov); 
             Base.write(10);
             delay(tempomov);
             Garra.write(111);
             delay(tempomov);
             Art.write(170);
             delay(tempomov);
             Garra.write(37);
             delay(pausadramatica);
             
             // Take to drop zone
             Art.write(21);
             delay(tempomov);
             Base.write(60);
             delay(tempomov);
             Art.write(170);
             delay(tempomov);
             Garra.write(111);
             delay(tempomov);
             Art.write(21);
             digitalWrite(Buzzer, HIGH);
             delay(tempobuzzer);
             digitalWrite(Buzzer, LOW);

            Sair = digitalRead(pinBotaoSair);
            }while(Sair == LOW);
            textoRecebido = "Fim";
            Serial.println(textoRecebido);
            }
     
           /*Caso o usuário digite algo diferente dos comandos padrão, o programa 
            irá printar "Opção Inválida" e não irá funcionar*/
            if((textoRecebido != "Esquerda\0") && (textoRecebido != "Direita\0") && (textoRecebido != "Fim\0")){
            Serial.println("Opção Inválida");
            digitalWrite(Buzzer, HIGH);
            delay(tempoinvalido);
            digitalWrite(Buzzer, LOW);
            delay(tempoinvalido);
            digitalWrite(Buzzer, HIGH);
            delay(tempoinvalido);
            digitalWrite(Buzzer, LOW);
            delay(tempoinvalido);
            }      
     
        textoRecebido = ""; // clears what was stored on the variable to recieve a new string
    }
     
     }else{
    digitalWrite(led[0], LOW);
     }

// Manual phase
if(fase == 2){
  digitalWrite(led[1], HIGH);
  
  // SErvos control (variables that recieve the analog ports signal)
  potBase = analogRead(A0);  
  potArt = analogRead(A3);
  potGarra = analogRead(A5);

  // map: transforms info from the potenciometer (0 - 1023 bytes) to angular position of the servos (0 - 179°)
  AngBase = map(potBase, 0, 1023, 0, 179);
  AngArt = map(potArt, 0, 1023, 0, 179);
  AngGarra = map(potGarra, 0, 1023, 0, 179);

  // Transmits angular position to the servos
  Base.write(AngBase);
  Art.write(AngArt);
  Garra.write(AngGarra);


   }else{
  digitalWrite(led[1],LOW);
}   
}
