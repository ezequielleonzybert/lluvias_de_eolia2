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
  else if(slider.hover_slideL){
    translation.set(width, 0 );
    ui.menu1_position.add(translation);
    ui.menu1_target_position.add(translation);
    ui.menu1_hide_position.add(translation);
    ui.menu1_show_position.add(translation);
    ui.menu2_position.add(translation);
    ui.menu2_target_position.add(translation);
    ui.menu2_hide_position.add(translation);
    ui.menu2_show_position.add(translation);
    for(Particle p : particles){
      PVector newPos =  new PVector();
      p.position.add(translation);
    }
  }
  else if(slider.hover_slideR){
    translation.set(-width, 0 );
    ui.menu1_position.add(translation);
    ui.menu1_target_position.add(translation);
    ui.menu1_hide_position.add(translation);
    ui.menu1_show_position.add(translation);
    ui.menu2_position.add(translation);
    ui.menu2_target_position.add(translation);
    ui.menu2_hide_position.add(translation);
    ui.menu2_show_position.add(translation);
    for(Particle p : particles){
      PVector newPos =  new PVector();
      p.position.add(translation);
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

  
  boolean circleHover(PVector p, float radius , float margin){
    if(mouse_position.dist(p) < radius + margin ){
        return true;
      }
      else{
      return false; 
      }
  }

  //método para detectar hovers sobre rectangulos
  boolean rectHover( PVector position , float w , float h , float margin){
    if(
      mouseX > position.x - w * .5 - margin && mouseX < position.x + w * .5  + margin &&
      mouseY > position.y - h * .5 - margin && mouseY < position.y + h * .5 + margin
    ){
      return true;
    }
    else return false;
  }