class Particle{
  PVector position, acceleration, velocity;
  float radius;
  char tone;
  boolean hover, drag, delete;
  color particle_color;
  
  Particle(PVector position, char tone){
    this.position = position;
    velocity = new PVector(0,0);
    acceleration = gravity;
    radius = width/60;
    this.tone = tone;
    particle_color = ui.circle_color;
  }
  
//---------------------------------UPDATE------------------------------


  void update(){ 
    
    //Físicas y disparar sonidos
    //Si la partícula esta suelta:
    if(!drag){
      velocity.add(acceleration);
      PVector nextPosition = position.add(velocity);  
      if(nextPosition.y + radius > height || nextPosition.y - radius < 0){
        velocity.y *= -1;
        switch(tone){
          case 'c':
            samplers[0].trigger();
          break;
          case 'd':
            samplers[1].trigger();
          break;
          case 'e':
            samplers[2].trigger();
          break;
          case 'f':
            samplers[3].trigger();
          break;
          case 'g':
            samplers[4].trigger();
          break;
          case 'a':
            samplers[5].trigger();
          break;
          case 'b':
            samplers[6].trigger();
          break;
          case 'C':
            samplers[7].trigger();
          break;
        }
      }   
      position.add(velocity);
    }
    //Si la partícula esta siendo arrastrada:
    else{
      //si el mouse sale de la ventana:
      float margin = radius + 10;
      if(mouse_position.x > width - margin){
        mouse_position.x = width - margin;
      }
      else if(mouse_position.x < margin){
        mouse_position.x = margin;
      }
      if(mouse_position.y > height - margin){
        mouse_position.y = height - margin;
      }
      else if(mouse_position.y < margin){
        mouse_position.y = margin;
      }
      
      position.lerp(mouse_position, 0.1);
      velocity.set(0,0);

      //Preparando para eliminar partícula:
      if(ui.hover_trash){
        delete = true;
      }
      else{
        delete = false;
      }
    }
    
    //Hover & Drag
    if(mouse_position.dist(position) < radius + 20){
      hover = true;
      if(mousePressed && !ui.drag_tune){
        drag = true;
        drag_particle = true;
        velocity.set(0,0);
      }
      else{
        drag = false;
      }
    }
    else{
     hover = false;
    }
  }

//---------------------------------RENDER------------------------------

  void render(){
    stroke(c5);
    strokeWeight(1.5);
    fill(particle_color);
    circle(position.x,position.y,radius*2);
  }
}
