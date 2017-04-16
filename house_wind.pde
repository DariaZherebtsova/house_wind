
float angle = 0.0;
float delta_angle = 0.8;
float x, xt;
float y, yt; 
int num_f_w = 10;//число летящих окон
float[] x0 = new float[num_f_w];
float[] y0 = new float[num_f_w];
float[] x1 = new float[num_f_w];
float[] y1 = new float[num_f_w]; 
float[] x2 = new float[num_f_w];
float[] y2 = new float[num_f_w]; 
float[] step_x = new float[num_f_w];
//float step_x = 2;
float[] xi = new float[30];
float[] yi = new float[30];
int step[] = new int[50];
int num_step;
String act[] = {"20 right", "60 up","64 right","60 down","25 right", "120 up","90 right","120 down",
                "20 right", "85 up", "105 right", "85 down",
                "30 right", "140 up","50 right","140 down","15 right", "140 up","50 right","140 down",
                "15 right", "60 up","147 right","60 down","50 right"};   
float x_win_1;
float y_win_1; 

//с какого значения Х расчитывать окна
int m_x_win[] = {27, 114, 224, 360, 424, 490};
int m_y_win[] = {248, 188, 224, 168, 168, 248};
//кол-во столбцов окон
int m_s_win[] = {4, 6, 7, 3, 3, 10};
//кол-во рядов окон
int m_r_win[] = {5, 10, 7, 12, 12, 5};   
int size_wind = 5;
int size_wind_w = 4;
int size_wind_h = 5;
int pr_wind = 6; //промежуток между окнами по вертикали
int tr_wind = 2; //промежуток между окнами по горизонтали
//для рандома без повторов массив индексов окон
int mass_rr_win[] = new int[300];
int mrro = 0;//счетчик массива
int f_stop_fly = 0;
int f_stop_all = 0;
int stop_frame = 0;

int f_first_wind = 0;
int f_five_win = 0; //через 5 окон 3 закрашиваем
int[] f_win_fin = new int[num_f_w];

int start_lettr = 15;
int interval[] = {0,5,9,9,5,19,3,1,1,2,1,1,3,33,28,20,2,2,1,2,1,2,2};
int letter[] =    {9,1,1,1,9,3, 1,1,1,1,1,1,1,8 ,8, 2, 1,1,1,1,1,1,2};

int mass_lettr[] = new int[100];
int mb;

int radius_min, radius_max;
int speed;

//класс для хранения координат
class XY {
  float x;
  float y;
  //конструктор
  XY(float tempX, float tempY) {
    x = tempX;
    y = tempY;
  }
  void print_xy()
  {
    println(x, ",", y);
  }
}

//массив с координатами окон
XY[] k_win = new XY[1000];
//массив прилетевших окон
XY[] mass_win = new XY[300];
//реальное кол-во окон
int num_k_win, mw=0;
//текущее окно
int ii_w = 0;

//массив индексов прилетевших окон в массиве k_win
int ind_win[] = new int[500];
int iw=0; //cчетчик для массива ind_win[]
int ikk = 0;
//массив индексов стираемых окон 
int mass_erase[] = new int[300];
int er = 0;//cчетчик для массива

//================================
void setup() {
  size(650, 490);
  smooth();
  frameRate(60);
  speed = 1;
  
  //координаты начала рисования (горизонта)
  xi[0] = 0;
  yi[0] = 300;
  //текущие координаты
  xt = xi[0];
  yt = yi[0];
  
  //параметры вспышки
  radius_min = 5;
  radius_max = 20;
  
  //цвет линии
  stroke(254);
  //цвет фона
  background(0);
  //толщина линии
  strokeWeight(2);  
  
  //шаг
  //массив начинается с нуля для задания условия больше/меньше
  step[0] = 0;
  //номер шага
  num_step = 0;
  //счетчик для массива step[]
  int k = 1;
  //до какого frameCount идет шаг 
  int stp = 0; //значение, хранящееся в массиве step[]
//----------------------------  
  //разбираем массив act[]
//----------------------------  
  //формируем массив step[] - "временные отрезки" когда движемся в одном направлении
  for (int i=0; i < act.length; i++)
  {
    //вычленяем из строки числа
    String act_i[] = match(act[i], "\\d+");
    //если получилось
    if (act_i != null)
    {
      //присваиваем первый элемент, т.к. у нас одно число
      stp += int(act_i[0]); //на сколько двигаться
      //делим на 5, т.к. будем двигаться по 5 пикс.
      step[k] = stp/5;
      //println(step[k]);
      k++;
    }
  }
  
  
  //заполняем массив с координатами окон
  //x_win_1 = 27;
  num_k_win = 0;
  for (int z=0; z<6; z++)
  {
    x_win_1 = m_x_win[z];
    y_win_1 = m_y_win[z];
    for (int j=0; j<m_s_win[z]; j++)
    {
      for (int i=0; i<m_r_win[z]; i++)
      {
        k_win[num_k_win] = new XY(x_win_1, y_win_1+(size_wind + pr_wind)*i);
        //k_win[num_k_win].print_xy();
        num_k_win++;
      }
      
      x_win_1 = x_win_1 + (size_wind + tr_wind)*2;
      //println(x_win_1);
    } 
  }
  
  int start_lettr = 20;
  mb = 0;
  //формируем массив для букв
  for (int i=0; i<letter.length; i++)
  {
    //прибавляем интервал
    start_lettr = start_lettr + interval[i];
    for (int j=0; j<letter[i]; j++)
    {
       start_lettr++;
       //println(start_lettr);
       mass_lettr[mb] = start_lettr;
       mb++;
       
    }
  }

  //откладываем старт
  //delay(15000);  
}
//-------------draw------------------------------
void draw() {
  //каждый раз "очищается" фон
      background(0);
      
  if (f_stop_fly == 1) println("__________frameCount ",frameCount);  
  if(frameCount > 2200)
  {
      exit();
  }
    
  if (f_stop_all != 1)
  {
  //если последний шаг
      if (num_step == act.length)
      {
        //второй этап
        //полет окон
        line_n(num_step);
        wind_arrive();  //прилетевшие окна
        //if (f_stop_fly!=1)
        //{
          fly_wind();
        //}
        //else
        //{
        //  stop_frame = frameCount;
          
        //  f_stop_all = 1;
          
       // }
        
        
      }
      else
      {
    
        //границы значения номера кадра для текущего шага
        if ((frameCount > step[num_step]) && (frameCount <= step[num_step+1]))
        {
          //рисуем предыдущие шаги
          line_n(num_step);
          //изменяем текуший x или y, в зависимости от условий шага (act[])
          actiwn(act[num_step]); //yt = yt - 5; up
          //println("xt " + xt);
          //println("yt " + yt);
          //линия от последней точки предыдущего шага до текущих x,y
          line(xi[num_step], yi[num_step], xt, yt);
        }
        //сохраняем координаты последней точки текущего шага 
        if (frameCount == step[num_step+1])
        {
          xi[num_step+1] = xt;
          yi[num_step+1] = yt;
   //переходим к следующему шагу       
          num_step++;
        }
        
      }
      //эффект искр на фитиле (бикфордов шнур) 
      flash(xt, yt);
      //замедляем
    //  delay(speed);
  }
  else
  {
    println("frameCount ", frameCount);
    if(frameCount < (stop_frame+17))
    {
      println("ooo ");
      line_n(num_step);
      wind_arrive();  //прилетевшие окна
    }
    
    if(frameCount > 2000)
    {
      exit();
    }
    
  }
}
//------------------------

void random_rect(float tx, float ty, int size_w, int size_h)
{
    //float tl = random(1,4);
    //float tr = random(1,4);
    float br = random(1,4);
    float bl = random(1,4);
    rect(tx, ty, size_w, size_h, 1, 1, br, bl);
}

//рандом без повторов
int random_num_wind(int max)
{
  int rr = int(random(0,max));
  //проверяем что такого числа еще не было
  
  while (find_in_mass(rr) == true)
  {
    rr = int(random(0,max));
  }
  //добавляем его в массив
  mass_rr_win[mrro] = rr;
  mrro++;
  if (mrro == max)
  {
    println("-------stop---------");
    f_stop_fly = 1;
    //f_first_wind = 0;
  }
  return rr;  
}

//проверяем содержит ли массив это значение
boolean find_in_mass( int rm)
{
  for (int i=0; i<mrro; i++)
  {
    if (rm == mass_rr_win[i])
    {
      return true;
    }
  }
  
  return false;
}

void fly_wind()
{ 
 if (f_stop_fly == 1) println("f_first_wind ",f_first_wind);
  //первый заход
  if (f_first_wind == 0)
  {
    println("-- new 3 wind ");
    f_first_wind = 1;
    
    for (int i=0; i<(num_f_w-1); i++)
    {
      f_win_fin[i] = 0;
      //выбираем окно----------------
      ii_w = random_num_wind(num_k_win);
      //println("random ",ii);
      x2[i] = k_win[ii_w].x;
      y2[i] = k_win[ii_w].y;
      //println("х2 ",x2);
      //cписок вылетевших окон
      ind_win[iw] = ii_w;
      println("start ",i," x2 ",x2[i]);
      iw++;      
    }
    
    //плюс окно, входящее в букву
    f_win_fin[num_f_w-1] = 0;
    //выбираем индекс
      ii_w = int(random(0,mb));
      int jj_ok = mass_lettr[ii_w];
      x2[num_f_w-1] = k_win[jj_ok].x;
      y2[num_f_w-1] = k_win[jj_ok].y;
      println("start ",num_f_w-1," x2 ",x2[num_f_w-1]);
      
    //-------------------------------
    //выбираем откуда лететь
    for (int i=0; i<num_f_w; i++)
    {
      x1[i] = int(random(0,650));
      while (x1[i] == x2[i])
      {
        x1[i] = int(random(0,650));
      } 
  
      y1[i] = int(random(0,420));
  
      x0[i] = x1[i];
      step_x[i] = 3;
      if (x1[i] > x2[i]) step_x[i] = -step_x[i];
    }
  } 
  
  for (int i=0; i<num_f_w; i++)
  {
    if (f_stop_fly == 1) println("f_win_fin[",i,"]= ",f_win_fin[i]);
    if (f_win_fin[i] != 1)
    {
      //paсчет координат на траектории полета
      if (abs(x2[i] - x0[i]) > 5) //пока не дойдем до х2
      {
        
        x0[i] = x0[i] + step_x[i];
        y0[i] = (x0[i]-x1[i])*(y2[i]-y1[i])/(x2[i]-x1[i])+y1[i];
        random_rect(x0[i], y0[i], size_wind_w, size_wind_h);
        println("---step x",i);
      }
      else 
      {
        //прилетели
        random_rect(x2[i], y2[i], size_wind_w, size_wind_h);
        f_win_fin[i] = 1;
        f_five_win++;
        println("=========f_five_win ",f_five_win);
        
        if (f_stop_fly == 1)
        {
          //ждем когда все долетят
          int ok=0;
          for (int ii=0; ii<num_f_w; ii++)
          {
            if (f_win_fin[ii]==1)
            {
              ok++;
            }
          }
          println("прилетели ",ok, " из ",num_f_w);
          if (ok==num_f_w)
          {
            
            println("==========vse doma============ ");
          }
        }  
        //   f_first_wind = 0;
        //println("random ",ii_w);
        
        mass_win[mw] = new XY(x2[i], y2[i]);
        mw++;
        println("прилетело ",i,"ое всего окон ",mw);
      };
    }
    else
    {
       if (f_stop_fly != 1)
       {
           //окно прилетело
           f_win_fin[i] = 0;
       
           //выбираем новое окно----------------
           if (i == (num_f_w-1))
           {
             //окно входящее в букву
             //выбираем индекс
            ii_w = int(random(0,mb));
            int jj_ok = mass_lettr[ii_w];
            x2[num_f_w-1] = k_win[jj_ok].x;
            y2[num_f_w-1] = k_win[jj_ok].y;
    
           }
           else
           {
             ii_w = random_num_wind(num_k_win);
             //println("random ",ii);
             x2[i] = k_win[ii_w].x;
             y2[i] = k_win[ii_w].y;
             //println("х2 ",x2);
           }
            
           //выбираем откуда лететь
           x1[i] = int(random(0,650));
           while (x1[i] == x2[i])
           {
             x1[i] = int(random(0,650));
           } 
      
           y1[i] = int(random(0,420));
      
           x0[i] = x1[i];
           step_x[i] = 5;
           if (x1[i] > x2[i]) step_x[i] = -step_x[i];
           
           //cписок вылетевших окон
           ind_win[iw] = ii_w;
           println("start ",i," x2 ",x2[i]);      
           iw++;
           println("вылетело окон ",iw);
       }
       
       
    }  
    
    
  }
  
}

//-----------------------------------------------

//выполняет изменение текущих координат
//в соответствии с условиями шага
void actiwn( String act_s)
{
  //извлекаем из строки нужную информацию
  String act_i[] = match(act_s, "[a-z]+");
  if (act_i != null)
  {
      //println("__" + act_i[0] +"__");
      switch(act_i[0])  {
        case "up":
          yt = yt - 5;
          break;
        case "down":
          yt = yt + 5;
          break;
        case "left":
          xt = xt - 5;
          break;
        case "right":
          xt = xt + 5;
          break;
      }  
  }   
}

//рисует линии пройденных шагов
//входной параметр - количество линий
void line_n(int n)
{
  for (int i = 1; i<=n; i++) 
  {
    line(xi[i-1], yi[i-1], xi[i], yi[i]);
  }
}

void flash( float x0, float y0)
{
   //угол с которого начинаем
    angle = random(0, 5);
    //шаг с которым меняем угол
    delta_angle = random(0.4, 0.9);
    //рисуем восемь линий
    for (int i=0; i<8; i++) {
      //расстояние от центра
      int radius = int(random (radius_min, radius_max));
      //координаты точки на окружности
      x = x0 + cos(angle) * radius;
      y = y0 + sin(angle) * radius;
      line( x0, y0, x, y);
      angle += delta_angle;
      //delay(40);
    } 
}

boolean el_mass(int el)
{
 // println("el_mass ",el);
  for (int i=0; i<mb; i++)
  {
    //print(" ",mass_lettr[i]);
    if (el == mass_lettr[i])
    {
     // println("============vhodit========= ");
      return true;
    }
  }  
  return false;
}

void wind_arrive()
{
  if (f_stop_fly == 1) println("wind_arrive() ");
  //прилетевшие окна
  for (int i=0; i < mw; i++)
  {
    random_rect(mass_win[i].x, mass_win[i].y, size_wind_w, size_wind_h);
  }
  
  //когда mw>5 начинаем стирать окна не входящие в буквы
  if (mw>150)
  {
    frameRate(90);
    if (f_five_win > 2)
    {
      f_five_win = 0;
      for (int k=0; k<7; k++)
      {
          //берем "индекс" прилетевшего окна 
          println("_ikk_ ", ikk);
          int ind_del = ind_win[ikk];
          println("ind_del ", ind_del);
          //смотрим не входит ли он в букву
          if (el_mass(ind_del) == false)
          {
            println("ne vhodit ");
            mass_erase[er] = ind_del;
            er++;
            println("++er ", er);//число прилетевших окон
          } 
          ikk++;     
      }       
    }
  }
 
  //стираем проверенные (из массива mass_erase)
  //println("er ", er);//число прилетевших окон
  for (int i=0; i<er; i++)
  {
    //закрашиваем
    //fill(250,0,0);
    //stroke(250,0,0);
    fill(0);
    stroke(0);
    //println("red ", mass_erase[i]);
    rect(k_win[mass_erase[i]].x, k_win[mass_erase[i]].y, size_wind, size_wind);
    //delay(500);
    //возвращаем цвет
    fill(255);
    stroke(255);
  }
   
  //if (f_stop_fly == 1)
  //{
  //  delay(500);
  //}
}