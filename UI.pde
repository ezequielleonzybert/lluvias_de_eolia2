class UI{
  PVector position, target_position, hide_position, show_position, circle_position, tune_position, trash_position;
  float w, h, margin, radius, show_radius, hide_radius, target_radius, tune_angle;
  boolean hover_circle, hover_tune, hover_volume, hover_trash, drag_tune, position_locked;
  PShape pot, border, circle, triangle, trash;
  char tune, ptune;
  color circle_color;
  
 //----------------------------------CONSTRUCTOR-------------------------------------------

  UI(){
    w = width / 4 ;
    h = w / 2;
    hide_position = new PVector(width/2, -h/2.5); //si pongo = position no funciona
    show_position = new PVector(width/2, 0);
    position = new PVector(width/2, -h/2.5);
    target_position = new PVector(width/2, -h/2.5);
    circle_position = new PVector();
    tune_position = new PVector();
    trash_position = new PVector();
    tune_angle = 0;
    hide_radius = h/7.5;
    show_radius = h/5.5;
    radius = hide_radius;
    target_radius = radius;
    tune = 'f';
    ptune = ' ';
    circle_color = color4;
  }

 //-------------------------------------UPDATE---------------------------------------

  void update(){
    
    //Posición de menu y AUTO-HIDE
    if(
      mouseX > position.x - w/2 && 
      mouseX < position.x + w/2 &&
      mouseY < h/2 + 20
      ){        
      target_position.set(show_position);
      target_radius = show_radius;
      frame = -1;
    }
    else if(position.y == show_position.y){
      target_position.set(hide_position); 
      target_radius = hide_radius;
      if(frame == -1){
        frame = frameCount;
      }      
    }

    if(drag_tune && position.y == show_position.y){
      frame = frameCount;
    }
    float frameDif = frameCount - frame;
    
    if(frameDif > 60 || frameCount < 60){
      position.lerp(target_position, 0.1);
      radius = lerp(radius,target_radius,0.1);
      circle_position.set(position.x -w/3.2, position.y + h/4);
      tune_position.set(position.x, position.y + h/4);
      trash_position.set(position.x + w/3.2, position.y + h/4);
    }

    if(target_position.y == show_position.y && show_position.y - position.y < 0.01){
      position.set(show_position);
    }
    
    //Hovers
    hover_circle = getHover(circle_position);
    hover_tune = getHover(tune_position);
    hover_trash = getHover(trash_position);

    //cambio de tono
    if(drag_tune){
      float step = PI/4;

      if(tune_angle > 0){
        if(tune_angle > 3 * step){
          tune = 'C';
          circle_color = color1;
          if(ptune != tune){
            ptune = tune;
            select_C.rewind();
            select_C.play();
          }
        }
        else if(tune_angle > 2 * step){
          tune = 'b';
          circle_color = color2;
          if(ptune != tune){
            ptune = tune;
            select_b.rewind();
            select_b.play();
          }
        }
        else if(tune_angle > step){
          tune = 'a';
          circle_color = color3;
          if(ptune != tune){
            ptune = tune;
            select_a.rewind();
            select_a.play();
          }
        }
        else{
          tune = 'g';
          circle_color = color4;
          if(ptune != tune){
            ptune = tune;
            select_g.rewind();
            select_g.play();
          }
        }
      }
      else{
        if(tune_angle < -3 * step){
          tune = 'c';
          circle_color = color8;
          if(ptune != tune){
            ptune = tune;
            select_c.rewind();
            select_c.play();
          }
        }
        else if(tune_angle < -2 * step){
          tune = 'd';
          circle_color = color7;
          if(ptune != tune){
            ptune = tune;
            select_d.rewind();
            select_d.play();
          }
        }
        else if(tune_angle < -step){
          tune = 'e';
          circle_color = color6;
          if(ptune != tune){
            ptune = tune;
            select_e.rewind();
            select_e.play();
          }
        }
        else{
          tune = 'f';
          circle_color = color5;
          if(ptune != tune){
            ptune = tune;
            select_f.rewind();
            select_f.play();
          }
        }
      }
    }    
  }
  
//------------------------------------RENDER-----------------------------------------

  void render(){
    
    //Barra
    noStroke();
    rectMode(CENTER);
    fill(c2);
    rect(position.x, position.y, w, h, w/12);
    rectMode(CORNER);
    
    //si la barra no está oculta renderizar los botones
    if(position.y - hide_position.y > 0.01){

      //Render Círculo
      noStroke();
      if(hover_circle && !mousePressed){
        fill(c5);
        circle(circle_position.x, circle_position.y, radius*2);
        fill(circle_color);
        circle(circle_position.x, circle_position.y, radius*1.8);
      }
      else{
        fill(c4);
        circle(circle_position.x, circle_position.y, radius*2);
        fill(circle_color);
        circle(circle_position.x, circle_position.y, radius*1.8);
        fill(128,100);
        circle(circle_position.x, circle_position.y, radius*1.8);
      }
      
      //Render Selector de tono
      pot = createShape(GROUP);
      border = createShape(ELLIPSE, 0, 0, radius*2, radius*2);
      circle = createShape(ELLIPSE, 0, 0, radius*1.5, radius*1.5);
      triangle = createShape(TRIANGLE, 0, -radius*.6, -radius/9, -radius/4, radius/9, -radius/4);
      pot.addChild(border);
      pot.addChild(circle);
      pot.addChild(triangle);
      pot.rotate(tune_angle);
      //Hover selector de tono
      if(drag_tune || bool_cursor){
        circle.setFill(c1);
        border.setFill(c5);
        triangle.setFill(c5);        
      }     
      else if(hover_tune && !drag_particle){
        circle.setFill(c2);
        border.setFill(c5);
        triangle.setFill(c5);
      }
      else{
        border.setFill(c4);
        circle.setFill(c3);
        triangle.setFill(c4);
      }
      shape(pot,tune_position.x, tune_position.y);

      //Render bote de basura
      float 
        sbase = radius*1.3,
        ybase = sbase/5,
        sxl = sbase/11,
        syl = sbase / 1.5,
        xl = sbase * 0.26,
        sxtapa = sbase*1.1,
        sytapa = sbase/6,
        ytapa = sbase/1.5,
        ymanija = sbase/1.3,
        sxmanija = sbase/3,
        symanija = sbase/6,
        r = sbase / 5;
        

      rectMode(CENTER);
      trash = createShape(GROUP);
      PShape base = createShape(RECT, 0, ybase, sbase, sbase, 0, 0, r, r);
      PShape l1 = createShape(RECT, 0 , ybase, sxl, syl, r);
      PShape l2 = createShape(RECT, -xl , ybase, sxl, syl, r);
      PShape l3 = createShape(RECT, xl , ybase, sxl, syl, r);
      PShape tapa = createShape(RECT, 0, -ytapa + ybase, sxtapa, sytapa, r);
      PShape manija = createShape(RECT, 0, -ymanija + ybase, sxmanija, symanija, r,r,0,0);
      trash.addChild(base);
      trash.addChild(l1);
      trash.addChild(l2);
      trash.addChild(l3);
      trash.addChild(tapa);
      trash.addChild(manija);

      //Hover bote de basura
      if(hover_trash && !drag_tune && !bool_cursor){
        base.setFill(c5);
        l1.setFill(c2);
        l2.setFill(c2);
        l3.setFill(c2);
        tapa.setFill(c5);
        manija.setFill(c5);
      }
      else{
        base.setFill(c4);
        l1.setFill(c2);
        l2.setFill(c2);
        l3.setFill(c2);
        tapa.setFill(c4);
        manija.setFill(c4); 
      }

      shape(trash, trash_position.x, trash_position.y);
    }   
  }
  boolean getHover(PVector p){
    if(mouse_position.dist(p) < radius + 10){
        return true;
      }
      else{
      return false; 
      }
  }
}

//-----------------------------METHODS------------------------