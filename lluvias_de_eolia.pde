//Libreria para implementar las clases Robot y mouseInfo
import java.awt.*;
import java.awt.event.*; 
//Librería de control de sonidos
import ddf.minim.*;
import ddf.minim.ugens.*;

Minim minim;
AudioSample c, d, e, f, g, a, b, cc; 
AudioPlayer 
  select_c, select_d, select_e, select_f, 
  select_g, select_a, select_b, select_C,
  audio_delete, audio_grab;

// AUDIO
MultiChannelBuffer buffer;
AudioOutput output;
Sampler[] samplers;
float rate;
Gain gain;

PImage cursor, cursor_open, cursor_close;
PVector gravity, mouse_position;
Point point, prev_point;
int numParticles = 0, frame = -1;
ArrayList<Particle> particles = new ArrayList<Particle>();
UI ui;
Robot robot;
boolean bool_cursor, drag_particle;
color
  c1 = color(255),
  c2 = color(230),
  c3 = color(127),
  c4 = color(63),
  c5 = color(0),
  color1 = #FFFFFF,
  color2 = #EFFAFA,
  color3 = #D9F2F4,
  color4 = #C2EBED,
  color5 = #ABE3E6,
  color6 = #94DCE0,
  color7 = #7CD4D9,
  color8 = #66CDD3;

//-----------------------------------SETTINGS-----------------------------------------

void settings(){
  //fullScreen();
  size(1000,500);
}

//---------------------------------------SETUP------------------------------------------

void setup(){

  try { 
    robot = new Robot();
    robot.setAutoDelay(0);
  } 
  catch (Exception e) {}

  background(c2);
  noStroke();
  noCursor();
  imageMode(CENTER);
  
  gravity = new PVector(0, 0.15);
  
  //UI
  ui = new UI();
  
  //Cursores
  cursor_open = loadImage("image/cursor_open.png");
  cursor_close = loadImage("image/cursor_close.png");
  
  // AUDIO
  samplers = new Sampler[8]; //donde se cargan los archivos de sonido.
  minim = new Minim(this); //el objeto que hace todo lo relacionado al audio
  output = minim.getLineOut(); // el objeto que da la salida de audio

  for(int i = 0; i < 8; i++){ //cargo los sonidos en cada samplers[]
    samplers[i] = new Sampler("audio/" + str(i) + ".wav", 4, minim);
    gain = new Gain(-12); //le bajo la ganancia para que no sature al superponerse
    samplers[i].patch(gain).patch(output); //incluyo cada sample en la salida de audio
  }

//cargando los sonidos del UI, misma funcion que lo anterior pero otra manera de hacerlo. 
//Pero así no me deja controlar las ganancias, lo que en este caso no me interesa.
  select_c = minim.loadFile("audio/select_c1.wav", 512);
  select_d = minim.loadFile("audio/select_d.wav", 512);
  select_e = minim.loadFile("audio/select_e.wav", 512);
  select_f = minim.loadFile("audio/select_f.wav", 512);
  select_g = minim.loadFile("audio/select_g.wav", 512);
  select_a = minim.loadFile("audio/select_a.wav", 512);
  select_b = minim.loadFile("audio/select_b.wav", 512);
  select_C = minim.loadFile("audio/select_c2.wav", 512);
  audio_delete = minim.loadFile("audio/delete.wav", 512);
  audio_grab = minim.loadFile("audio/grab.wav", 512);
}

//-------------------------------------DRAW--------------------------------------------

void draw(){
  background(c5);
  mouse_position = new PVector(mouseX, mouseY);
  
  //Render UI
  ui.update();
  ui.render();
  
  //Render Particulas
  for(Particle p : particles){
    p.update();
    p.render();    
  }
  
  // Render Cursor
  if(!ui.drag_tune){
    if(mousePressed){
    cursor = cursor_close; 
    }
    else{
      cursor = cursor_open; 
    }
    if(!bool_cursor){
      image(cursor, mouseX, mouseY);  
    }
    else {
      bool_cursor = false;
    }
  }
}

//----------------------------------MOUSE-PRESSED-------------------------------------------

//entra una única vez y primero
void mousePressed(){ 
  PVector position = new PVector(mouseX, mouseY);

  //Crear partícula
  if(ui.hover_circle){
    particles.add(new Particle(position, ui.tune));
    drag_particle = true;
    audio_grab.rewind();
    audio_grab.play();
  }
  //cambiar tono
  else if(ui.hover_tune){
    ui.drag_tune = true;
    //guardando la posicion actual del mouse
    point = MouseInfo.getPointerInfo().getLocation();
    if(prev_point != null){
      robot.mouseMove((int)prev_point.getX(), (int)prev_point.getY());
    }
  }
} 

//----------------------------------MOUSE-DRAGGED-------------------------------------------

void mouseDragged() {
  if(ui.drag_tune){
    ui.tune_angle = constrain(map(mouseX, 0, width, -PI, PI), -PI, PI);
  }
}

//----------------------------------MOUSE-RELEASED-------------------------------------------

void mouseReleased() {
  if(ui.drag_tune){
    //guardando la posición actual del tune (mouse), luego la usaremos.
    prev_point = MouseInfo.getPointerInfo().getLocation();
    //reposicionando el cursor sobre el potenciometro
    robot.mouseMove((int)point.getX(), (int)point.getY()); 
    ui.drag_tune = false;
    bool_cursor = true;    
  }
  

  //Borrando particulas en el tachito
  if(drag_particle){
    if(ui.hover_trash){
      for(int i = particles.size(); i > 0; i--){
        if(particles.get(i-1).delete){
          particles.remove(i-1);
          audio_delete.rewind();
          audio_delete.play();
        }
      }
    }
    //Soltando particulas
    else{
      for(int i = 0; i < particles.size(); i++){
        particles.get(i).drag = false;
      }
    } 
    drag_particle = false;
  }
}
