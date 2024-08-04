/*
          Los permisos para la app de Android los obtuve desde
              C:\Program Files (x86)\Android\android-sdk\cmdline-tools\7.0\bin
          con cmd.exe (línea de comandos autorizado) ejecutando
              sdkmanager --licenses (darle sí a todo)
          Eso me generó la carpeta 'licenses' en
              C:\program files (x86)\Android\android-sdk
          la cual copié a
              Documentos\Processing\android\sdk
              
          El ícono de la app está en
              Documentos\Processing\modes\AndroidMode\icons
*/
int m_c;
int d_c;
int hh = hour();
int mm = minute();
int ss = second();
int transcurridos;
int b = 200;                                                                                      // ordenada para 'mejorar' la vista gráfica
float r = 100;                                                                                    // radio unitario por factor de scala (100)
double radio = r*sin (radians(23.45));                                                            // radio del círculo de fechas por factor de escala
double equis_aux, ye_aux;                                                                         // los cálculos de la fecha con doble precisión
float x, y, lambda;
float xp, yp;
float hora;
float angulo = 0.0;
PFont tipoLetra, resultado;

void setup() {
  size(500, 500, P3D); // 1000, 1000                                                              // 3D para invertir el eje Y
  background(0);

  lambda = -21.01;
  hora = (float) hour() + ((float) minute() / 60) + ((float) second() / 3600);
  XYFecha(day(), month(), year());                                                                // calcula las coordenadas de la fecha seleccionada
  x = (float) equis_aux;
  y = (float) ye_aux;
  
  resultado = createFont("SansSerif", 16);
}

void draw() {
  if (mouseX < 3*width/8 && mouseY > 5*height/8) {
    background(0);
    if ((pmouseX - mouseX) > 0) transcurridos--;
    if (transcurridos == -((es_bisiesto(year())) ? 81 : 80)) transcurridos = 285;
    if ((pmouseX - mouseX) < 0) transcurridos++;
    if (transcurridos == 286) transcurridos = 1 - ((es_bisiesto(year())) ? 81 : 80);
    double segmento_aux_min = (2.0 * PI * radio) / ((es_bisiesto(year())) ? 366 : 365);
    double theta = (transcurridos * segmento_aux_min * 180) / (PI * radio);
    x = (float) radio * sin (radians((float) theta));
    y = (float) radio * cos (radians((float) theta));                                                             
  }

  if (mouseX > 5*width/8 && mouseY > 5*height/8) {
    background(0);
    frameRate(60);
    if (hora < 6) hora = 6;
    if (hora > 18) hora = 6;
    hora += 0.01;
  }
  if ((pmouseX - mouseX) != 0  && mouseY < 5*height/8) {
    background(0);
    frameRate(30);
    if (lambda < -90) lambda = 90;
    if (lambda > 90) lambda = -90;
    if ((pmouseX - mouseX) > 0) lambda += 0.25;
    if ((pmouseX - mouseX) < 0) lambda -= 0.25;
  }

  pushMatrix();
    if (lambda < 0) translate(9*width/80, 11*height/16);
    else translate(35*width/40, 11*height/16);
    rosa (0, 0);
  popMatrix();

//  scale(1.75);
  if (lambda <= 0) translate(5*width/8, 15*height/32); // translate(6*width/16, 9*height/32);
  else  translate(3*width/8, 15*height/32); // translate(3*width/16, 9*height/32);
  stroke(255);
  rotateX(radians(180));                                                                          // sistema coordenado 'normal'

  pushMatrix();                                                                                   // graficación en sistema rotado según la latitud
    rotateZ(radians(lambda));                                                                     // el recoorido es contra el sentido de las manecillas del reloj
    stroke(180, 226, 244);
    arco((float) radio, 0, 360, 0, b, true);
    stroke(255, 255, 0);
    line(-x, b+y, 0, -x, 0, 0);                                                                   // fecha seleccionada
    if (lambda <= 0) arco(100, 90, 180, -150, 0, true);                                           // cuadrante horario
    else arco(100, 0, 90, 150, 0, false);
    strokeWeight(0.5);
    for (int l = 0; l <= 90; l+=15) {
      if (lambda <= 0)
        punteada(-150-r*sin(radians(90-l)), r*sin(radians(l)), (float) radio, r*sin(radians(l))); // horas de 6:00 a 12:00 y de 12:00 a 18:00
      else
        punteada((float) -radio, r*sin(radians(l)), 150+r*sin(radians(90-l)), r*sin(radians(l))); // horas de 6:00 a 12:00 y de 12:00 a 18:00
    }
    strokeWeight(1);
    stroke(255, 0, 0);
    if (hora >= 6 && hora <= 12) angulo = (hora - 6) * 15;
    if (hora > 12 && hora <= 18) angulo = (18 - hora) * 15;
    if (lambda <= 0)                                                                              // hora seleccionada
      line(-150-r*sin(radians(90-angulo)), r*sin(radians(angulo)), 0, -x, r*sin(radians(angulo)), 0);
    else                                                                                          // hora seleccionada
      line(-x, r*sin(radians(angulo)), 0, 150+r*sin(radians(90-angulo)), r*sin(radians(angulo)), 0);
    stroke(255, 255, 255);
    line(-(float) radio, r*cos(radians(23.45)), 0, 0, 0, 0);
    line((float) radio, r*cos(radians(23.45)), 0, 0, 0, 0);
    line(-(float) radio, b, 0, -(float) radio, 0, 0);                                             // solsticio de verano
    line(0, 0, 0, 0, b+(float) radio, 0);                                                         // equinoccios de primavera y otoño
    line((float) radio, b, 0, (float) radio, 0, 0);                                               // solsticio de invierno
  popMatrix();

  arco(r, 0, 180, 0, 0, true);
  stroke(0, 255, 0);
  arco(r, 0, 360, 0, -0.75*b, false);
  stroke(255, 255, 0);
    if (lambda <= 0) arco(100, 90, 270, -150, -150, true);                                        // cuadrantes horario
    else {
      arco(100, 270, 360, 150, -150, true);
      arco(100, 0, 90, 150, -150, true);
    }
  strokeWeight(0.5);
  for (int l = 0; l <= 180; l+=15) {
    if (lambda <= 0)                                                                              // horas de 6:00 a 12:00
      punteada(-150-r*sin(radians(l)), r*cos(radians(l))-0.75*b, r*sin(radians(l)), r*cos(radians(l))-0.75*b);
    else                                                                                          // horas de 6:00 a 12:00
      punteada(-r*sin(radians(l)), r*cos(radians(l))-0.75*b, 150+r*sin(radians(l)), r*cos(radians(l))-0.75*b);
  }

  for (int l = 0; l <= 90; l+=15) {
    rota(-x, r*sin(radians(l)), -lambda);
    strokeWeight(0.4);
    punteada(xp, -0.75*b-sqrt(r*r-xp*xp), xp, yp);                                                // líneas que definen la trayectoria del Sol
    strokeWeight(4);
    point(xp, -0.75*b+r*sin(radians(90-l)), 0);                                                   // de las 6:00 a las 12:00
    point(xp, -0.75*b-r*sin(radians(90-l)), 0);                                                   // de las 12:00 a las 18:00
  }

  for (int l = 0; l < 90; l+=15) {
    strokeWeight(0.25);
    arco(100*sin(radians(l)), 0, 360, 0, -0.75*b, false);
    strokeWeight(1);
  }

  if (hora >= 6 && hora <= 12) {
    rota(-x, r*sin(radians(angulo)), -lambda);
    stroke(255, 0, 0);
    line(xp, -0.75*b+r*sin(radians(90-angulo)), 0, xp, yp, 0);                                    // líneas que definen la hora seleccionada
    line(0, -0.75*b, 0, xp, -0.75*b+r*sin(radians(90-angulo)), 0);                                // dirección de la sombra
    arco(xp, 0, 360, 0, -0.75*b, false);
    stroke(255, 255, 0); // 100 -> 90 :: xp -> ?
  }

  if (hora > 12 && hora <= 18) {
    rota(-x, r*sin(radians(angulo)), -lambda);
    stroke(255, 0, 0);
    line(xp, -0.75*b-r*sin(radians(90-angulo)), 0, xp, yp, 0);                                    // líneas que definen la hora seleccionada
    line(0, -0.75*b, 0, xp, -0.75*b-r*sin(radians(90-angulo)), 0);                                // dirección de la sombra
    arco(xp, 0, 360, 0, -0.75*b, false);
    stroke(255, 255, 0);
  }

  strokeWeight(10);
  if (hora >= 6 && hora < 12) point(xp, -0.75*b+r*sin(radians(90-angulo)), 0);                    // de las 6:00 a las 12:00
  if (hora >= 12 && hora <= 18) point(xp, -0.75*b-r*sin(radians(90-angulo)), 0);                  // de las 12:00 a las 18:00
  strokeWeight(1);

  stroke(255, 255, 255);
  line(-200, 0, 0, 200, 0, 0);
  line(0, 0, 0, 0, -100-0.75*b, 0);

  rotateX(radians(180));
  float argumento = sqrt(xp*xp + r*sin(radians(90-angulo))*r*sin(radians(90-angulo)));
//  float omega = degrees(acos(argumento/100)); // 'altura del Sol'
  float tau = 1/tan(acos(argumento/100));
  arco(argumento, 0, 360, 0, 0.75*b, false);
  textFont(resultado);
  textSize(16);
  if ((argumento / 100) < 1) {
    if (lambda <= 0) text("altura = " + tau + " x metro", -7*width/256, -33*height/128);
    else text("altura = " + tau + " x metro", 41*width/256, -33*height/128);
  }
  else {
    if (lambda <= 0) {
        if (hora < 12) text("No hay sombra", -23*width/64, height/25);
        else  text("Ya no hay sombra", -23*width/64, height/25);
    }
    else {
        if (hora < 12) text("No hay sombra", 25*width/128, height/25);
        else  text("Ya no hay sombra", 23*width/128, height/25);
    }
  }
  fecha(transcurridos);
  if (lambda <= 0) {
    text(d_c + "/" + m_c + "/" + year(), -11*width/32, -33*height/128);
    text("(" + floor(hora) + ":" + floor((hora-floor(hora))*60) + ")", -width/4, -33*height/128);
    text("\u03bb = " + (-lambda) + " N", -11*width/64, -33*height/128);
  }
  else {
    text(d_c + "/" + m_c + "/" + year(), -5*width/32, -33*height/128);
    text("(" + floor(hora) + ":" + floor((hora-floor(hora))*60) + ")", -width/16, -33*height/128);
    text("\u03bb = " + (-lambda) + " S", width/64, -33*height/128);
  }
}

void fecha (int dias) {
  int diaUltimo[] = {31, ((es_bisiesto(year())) ? 29 : 28), 31, 30, 31, 30, 31, 31, 30, 31, 30, 31}; 
  int temporal;
  int mes = 0;
  temporal = dias + ((es_bisiesto(year())) ? 81 : 80);
  while (temporal > 0) {
    temporal = temporal - diaUltimo[mes];
    mes++;
  }
  m_c = mes;
  d_c = temporal + diaUltimo[mes-1];
}

void XYFecha (int dia, int mes, int anio) {
  int diaUltimo[] = {31, ((es_bisiesto(anio)) ? 29 : 28), 31, 30, 31, 30, 31, 31, 30, 31, 30, 31}; 
  transcurridos = 0;
  for (int i=1; i < mes; i++)
    transcurridos = transcurridos + diaUltimo[i-1];
  transcurridos = transcurridos + dia - ((es_bisiesto(anio)) ? 81 : 80);
  double segmento_aux_min = (2.0 * PI * radio) / ((es_bisiesto(anio)) ? 366 : 365);
  double segmento_aux_fecha = transcurridos * segmento_aux_min;
  double theta = (segmento_aux_fecha * 180) / (PI * radio);
  equis_aux = radio * sin (radians((float) theta));
  ye_aux = radio * cos (radians((float) theta));   
}

boolean es_bisiesto (int anio) {
  if (anio%400 == 0) return true;
  if (anio%100 == 0 && anio%400 != 0) return false;
  if (anio%4 == 0) return true;
  return false;
}

void rota(float x, float y, float theta) {
  xp =  x * cos(radians(theta)) + y * sin(radians(theta));
  yp = -x * sin(radians(theta)) + y * cos(radians(theta));
}

void punteada(float x1, float y1, float x2, float y2) {
  float r = sqrt((x2 - x1)*(x2 - x1) + (y2 - y1)*(y2 - y1));
  float incr = r / 60.0;
  float theta = atan((y2 - y1) / (x2 - x1));
  float xi = x1;
  float yi = y1;
  float xf, yf;
  boolean b = true;

  for (float j = 0; j <= 60; j++) {
    xf = xi + incr * cos(theta);
    yf = yi + incr * sin(theta);
    if (b) line(xi, yi, 0, xf, yf, 0);
    b = !b;
    xi = xf;
    yi = yf;
  }
  strokeWeight(1);
}

void arco(float radio, int i, int f, float x, float y, boolean p) {
  float xi, yi, zi, xf, yf, zf;
  boolean b = true;
  if (i>f) i=f; 

  xi = radio*cos(radians(i)) + x;
  yi = radio*sin(radians(i)) + y;
  zi = zf = 0;
  for (int u = i; u <= f; u+=3) {
    xf = radio  * cos (radians(u)) + x;
    yf = radio  * sin (radians(u)) + y;
    if (p && b) line (xi, yi, zi, xf, yf, zf);
    if (!p) line (xi, yi, zi, xf, yf, zf);
    b = !b;
    xi = xf;
    yi = yf;
  }
}

void rosa(int a, int b) {
  float m = 3;
  pushMatrix();
    noStroke();
    fill (255, 255, 255, 255);

    rotateZ (radians(22.5));
    triangle (a, b, a+m, b+m, a, b+10*m);
    triangle (a, b, a-m, b+m, a, b+10*m);

    triangle (a, b, a+m, b-m, a, b-10*m);
    triangle (a, b, a-m, b-m, a, b-10*m);

    triangle (a, b, a+m, b+m, a+10*m, b);
    triangle (a, b, a+m, b-m, a+10*m, b);

    triangle (a, b, a-m, b+m, a-10*m, b);
    triangle (a, b, a-m, b-m, a-10*m, b);

    rotateZ (radians(-45));
    triangle (a, b, a+m, b+m, a, b+10*m);
    triangle (a, b, a-m, b+m, a, b+10*m);

    triangle (a, b, a+m, b-m, a, b-10*m);
    triangle (a, b, a-m, b-m, a, b-10*m);

    triangle (a, b, a+m, b+m, a+10*m, b);
    triangle (a, b, a+m, b-m, a+10*m, b);

    triangle (a, b, a-m, b+m, a-10*m, b);
    triangle (a, b, a-m, b-m, a-10*m, b);

    fill (255, 255, 255);
    noFill();
    stroke (255, 255, 255);
  popMatrix();
  
  m = 5.5;
  pushMatrix();
    rotateZ (radians(45));
    noStroke();
    fill (255, 128, 0, 255);
    triangle (a, b, a+m, b+m, a, b+10*m);
    fill (255, 255, 0, 255);
    triangle (a, b, a-m, b+m, a, b+10*m);

    fill (255, 255, 0, 255);
    triangle (a, b, a+m, b-m, a, b-10*m);
    fill (255, 128, 0, 255);
    triangle (a, b, a-m, b-m, a, b-10*m);

    fill (255, 255, 0, 255);
    triangle (a, b, a+m, b+m, a+10*m, b);
    fill (255, 128, 0, 255);
    triangle (a, b, a+m, b-m, a+10*m, b);

    fill (255, 128, 0, 255);
    triangle (a, b, a-m, b+m, a-10*m, b);
    fill (255, 255, 0, 255);
    triangle (a, b, a-m, b-m, a-10*m, b);

    fill (255, 255, 255);
    noFill();
    stroke (255, 255, 255);
  popMatrix();
  
  m = 7.5;
  noStroke();
  fill (255, 128, 0, 255);
  triangle (a, b, a+m, b+m, a, b+10*m);
  fill (255, 255, 0, 255);
  triangle (a, b, a-m, b+m, a, b+10*m);

  fill (255, 255, 0, 255);
  triangle (a, b, a+m, b-m, a, b-10*m);
  fill (255, 128, 0, 255);
  triangle (a, b, a-m, b-m, a, b-10*m);

  fill (255, 255, 0, 255);
  triangle (a, b, a+m, b+m, a+10*m, b);
  fill (255, 128, 0, 255);
  triangle (a, b, a+m, b-m, a+10*m, b);

  fill (255, 128, 0, 255);
  triangle (a, b, a-m, b+m, a-10*m, b);
  fill (255, 255, 0, 255);
  triangle (a, b, a-m, b-m, a-10*m, b);

  fill (255, 255, 255);
  noFill();
  stroke (255, 255, 255);
  textFont(resultado);
  textSize(20);
  text ("N", a-12*m, b+6);
  text ("S", a+10*m, b+6);
  text ("E", a-5, b-11*m);
  text ("O", a-5, b+13*m);
}
