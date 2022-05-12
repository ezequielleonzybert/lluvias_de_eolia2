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
            //c.trigger();
            sampler.trigger();
          break;
          case 'd':
            d.trigger();
          break;
          case 'e':
            e.trigger();
          break;
          case 'f':
            f.trigger();
          break;
          case 'g':
            g.trigger();
          break;
          case 'a':
            a.trigger();
          break;
          case 'b':
            b.trigger();
          break;
          case 'C':
            cc.trigger();
          break;
        }
      }   
      position.add(velocity);
    }
    //Si la partícula esta siendo arrastrada:
    else{
      position.lerp(mouse_position, 0.1);
      velocity.set(0,0);

      //Preparando para eliminar partícula
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
