import java.util.Set;
import java.util.Map;
import java.util.ArrayList;
import oscP5.*;///libreria osc
import netP5.*;///libreria net
OscP5 oscP5;///objeto osc
NetAddress myRemoteLocation;//objeto net

/*====| inicializacion de objetos importantes |====*/
Ideas ideas;
Cuerpos cuerpo[];
int cantidad = 10;//cantidad de rapsodas
Matrices matris[][];
int cant_mat_x = 100;//cantidad de cuadros en x
int cant_mat_y = 1;//cantidad de cuadros en y


void setup() {
    ideas = new Ideas("test.txt");
    size(1366, 768);//pantalla

    /*====| creacion de los cuerpos |====*/
    cuerpo = new Cuerpos[cantidad];
    for ( int i=0; i<cantidad; i++ ) {
        cuerpo[i] = new Cuerpos(i, ideas);//inicio cada objeto
    }

    /*====| creacion de la matris |====*/
    matris = new Matrices [cant_mat_x][cant_mat_y];//inico clase
    for ( int i=0; i<cant_mat_x; i++ ) {
        for ( int j=0; j<cant_mat_y; j++ ) {
            matris[i][j] = new Matrices(i, j, cant_mat_x, cant_mat_y);//inicio cada objeto
        }
    }

    /*====| coneccion con Pure Data |====*/
    oscP5 = new OscP5(this, 12001);//puerto de escucha de osc
    myRemoteLocation = new NetAddress("127.0.0.1", 9001);//id de envio de datos y puerto

    background(0);
}

void draw() {
    noStroke();
    //fill(0, 0, 0, 15);
    fill(int(random(0, 255)), int(random(0, 255)), int(random(0, 255)), 15);
    rect(0, 0, width, height);

    /*====| movimiento de los cuerpos |====*/
    for ( int i=0; i<cantidad; i++ ) {
        cuerpo[i].update();
    }

    /*====| revisar estado de la matris |====*/
    for ( int i=0; i<cant_mat_x; i++ ) {
        for ( int j=0; j<cant_mat_y; j++ ) {
            boolean ocupado = false;
            boolean encontro = false;
            for ( int k=0; k<cantidad; k++ ) {
                ocupado = matris[i][j].compara(cuerpo[k].x, cuerpo[k].y);
                if (ocupado) {
                    encontro=true;
                }
            }
            matris[i][j].update(encontro);
        }
    }

    /*====| dibujo cuerpo |====*/
    for ( int i=0; i<cantidad; i++ ) {
        cuerpo[i].dibuja();
    }

    /*====| dibjujo matris |====*/
    for ( int i=0; i<cant_mat_x; i++ ) {
        for ( int j=0; j<cant_mat_y; j++ ) {
        matris[i][j].dibujar();
            if (matris[i][j].enviar) {
                matris[i][j].enviar = false;
                /*====| envier mensaje por oscP5 |====*/
                OscMessage myMessage = new OscMessage("/t");//encabezado
                int numero = (i+1)+(cant_mat_y * j);
                myMessage.add(numero);//mensaje
                oscP5.send(myMessage, myRemoteLocation);//envio mensaje
                println(numero);
            }
        }
    }
    //envio osc
}