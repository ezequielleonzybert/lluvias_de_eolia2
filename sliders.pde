class Slider{

  // -----------------------------ATRIBUTOS--------------------------

  PVector 
    slideR_position,
    slideR_target_position,
    slideR_hide_position,
    slideR_show_position,
    slideL_position,
    slideL_target_position,
    slideL_hide_position,
    slideL_show_position;
  float 
    slide_w,
    slide_h;
  boolean 
    hover_slideL , hover_slideR;
  
  //----------------------------------CONSTRUCTOR-------------------------------------------
  Slider(){

    slide_w = ui.thickness;
    slide_h = slide_w * 2;
    slideR_position = new PVector( width + slide_w * .25 , height * .5 );
    slideR_hide_position = new PVector( width + slide_w * .25 , height * .5 );
    slideR_show_position = new PVector( width - slide_w * .5, height * .5 );
    slideR_target_position = new PVector( width + slide_w * .25 , height * .5 );
    slideL_position = new PVector( - slide_w * .25, height * .5 );
    slideL_hide_position = new PVector( - slide_w * .25 , height * .5 );
    slideL_show_position = new PVector( slide_w * .5, height * .5 );
    slideL_target_position = new PVector( - slide_w * .25 , height * .5 );

  }

  //-------------------------------------------------UPDATE--------------------------------------------------

  void update(){

        //posicion y auto-hide sliders
    if(rectHover(slideL_position , slide_w, slide_h, 20)){
      slideL_target_position.set(slideL_show_position) ;
      hover_slideL = true;
    }
    else{
      slideL_target_position.set(slideL_hide_position) ;
      hover_slideL = false;
    }
    slideL_position.lerp(slideL_target_position, 0.1);
    if(rectHover(slideR_position , slide_w, slide_h, 20)){
      slideR_target_position.set(slideR_show_position) ;
      hover_slideR = true;
    }
    else{
      slideR_target_position.set(slideR_hide_position) ;
      hover_slideR = false;
    }
    slideR_position.lerp(slideR_target_position, 0.1);

  }
  
  //------------------------------------RENDER-----------------------------------------

  void render(){

    rectMode( CENTER );
    noStroke();
    fill(c2);
    rect( slideR_position.x , slideR_position.y , slide_w , slide_h , ui.corners_radius , 0 , 0 , ui.corners_radius );
    rect( slideL_position.x , slideL_position.y , slide_w , slide_h , 0 , ui.corners_radius , ui.corners_radius , 0 );
    fill(c4);
    triangle( 
      slideR_position.x - slide_w / 4 , slideR_position.y - slide_w / 3 ,
      slideR_position.x - slide_w / 4 , slideR_position.y + slide_w / 3 ,
      slideR_position.x + slide_w / 3 , slideR_position.y  
    );
    triangle( 
      slideL_position.x + slide_w / 4 , slideL_position.y - slide_w / 3 ,
      slideL_position.x + slide_w / 4 , slideL_position.y + slide_w / 3 ,
      slideL_position.x - slide_w / 3 , slideL_position.y  
    );

  }
  
}
