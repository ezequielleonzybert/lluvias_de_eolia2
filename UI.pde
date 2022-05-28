class UI{

  // -----------------------------ATRIBUTOS--------------------------

  float thickness = width * .0625;

  PVector 
    menu1_position, 
    menu1_target_position,
    menu1_hide_position,
    menu1_show_position,
    menu1_circle_position,
    menu1_tune_position,
    menu1_trash_position,

    menu2_position, 
    menu2_target_position,
    menu2_hide_position,
    menu2_show_position,
    menu2_circle_position,
    menu2_pot1_position,
    menu2_pot2_position,
    menu2_trash_position;

  float 
    menu1_w, 
    menu1_h,
    menu2_w, 
    menu2_h,
    slide_w,
    slide_h,
    radius, //radio de los botones
    show_radius,
    hide_radius,
    target_radius,
    tune_angle,
    corners_radius;
  boolean 
    hover_circle,
    hover_tune,
    hover_volume,
    hover_trash,
    drag_tune,
    position_locked;
  PShape 
    pot,
    border,
    circle,
    triangle,
    trash;
  char tune, ptune;
  color circle_color;

  // -----------------------------------MÉTODOS--------------------------------------------
  
  //----------------------------------CONSTRUCTOR-------------------------------------------
  UI(){
    
    //MENU 1

    menu1_h = thickness;
    menu1_w = thickness * 3.5;
    menu1_hide_position = new PVector( width / 2 , - menu1_h / 4 );
    menu1_show_position = new PVector( width / 2 , menu1_h * .5 );
    menu1_position = new PVector( width /2 , - menu1_h / 4 );
    menu1_target_position = new PVector( width /2 , - menu1_h / 4 );
    menu1_circle_position = new PVector();
    menu1_tune_position = new PVector();
    menu1_trash_position = new PVector();
    tune_angle = 0;
    tune = 'f';
    ptune = ' ';
    circle_color = color4;

    //MENU 2

    menu2_h = thickness;
    menu2_w = thickness * 3.5 ;
    menu2_hide_position = new PVector( width + width / 2 , - menu2_h / 4 );
    menu2_show_position = new PVector( width + width / 2 , menu2_h * .5 );
    menu2_position = new PVector(width + width /2 , - menu2_h / 4 );
    menu2_target_position = new PVector( width + width /2 , - menu2_h / 4 );
    menu2_circle_position = new PVector();
    menu2_pot1_position = new PVector();
    menu2_pot2_position = new PVector();
    menu2_trash_position = new PVector();

    //ALL menus
    hide_radius = menu1_h * .25;
    show_radius = menu1_h * .35;
    radius = hide_radius;
    target_radius = radius;    
    corners_radius = menu1_w * .075;

  }

  //-------------------------------------------------UPDATE--------------------------------------------------

  void update(){

    //posicion y auto-hide menu 1
    if(rectHover( menu1_position , menu1_w , menu1_h , 20 )){        
      menu1_target_position.set(menu1_show_position) ;
      target_radius = show_radius;
      frame = -1;
    }
    else if(menu1_position.y == menu1_show_position.y){
      menu1_target_position.set(menu1_hide_position);
      target_radius = hide_radius;
      if(frame == -1){
        frame = frameCount;
      }      
    }

    if(drag_tune && menu1_position.y == menu1_show_position.y){
      frame = frameCount;
    }
    float frameDif = frameCount - frame;
    
    if(frameDif > 60 || frameCount < 60){
      menu1_position.lerp(menu1_target_position, 0.1);
      radius = lerp(radius,target_radius,0.1);
    }
    menu1_circle_position.set(menu1_position.x - menu1_w /3.2, menu1_position.y);
    menu1_tune_position.set(menu1_position.x, menu1_position.y);
    menu1_trash_position.set(menu1_position.x + menu1_w /3.2, menu1_position.y);

    if(menu1_target_position.y == menu1_show_position.y && menu1_show_position.y - menu1_position.y < 0.01){
      menu1_position.set(menu1_show_position);
    }

   
    
    
    //Hovers
    hover_circle = circleHover(menu1_circle_position , radius , 10 );
    hover_tune = circleHover(menu1_tune_position , radius , 10 );
    hover_trash = circleHover(menu1_trash_position , radius , 10 );

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
    
    //MENU 1 y 2
    noStroke();
    rectMode(CENTER);
    fill(c2);
    rect( menu1_position.x , menu1_position.y , menu1_w, menu1_h, 0 , 0 , corners_radius , corners_radius );
    rect( menu2_position.x , menu2_position.y , menu2_w, menu2_h, 0 , 0 , corners_radius , corners_radius );
    rectMode(CORNER);
    
    //si la barra no está oculta renderizar los botones
    if(menu1_position.y - menu1_hide_position.y > 0.01){

      //Render Círculo
      noStroke();
      if(hover_circle && !mousePressed){
        fill(c5);
        circle( menu1_circle_position.x , menu1_circle_position.y , radius*2);
        fill(circle_color);
        circle( menu1_circle_position.x , menu1_circle_position.y, radius*1.8);
      }
      else{
        fill(c4);
        circle(menu1_circle_position.x, menu1_circle_position.y, radius*2);
        fill(circle_color);
        circle(menu1_circle_position.x, menu1_circle_position.y, radius*1.8);
        fill(128,100);
        circle(menu1_circle_position.x, menu1_circle_position.y, radius*1.8);
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
      shape(pot,menu1_tune_position.x, menu1_tune_position.y);

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

      shape(trash, menu1_trash_position.x, menu1_trash_position.y);
    }

  }
  
}
