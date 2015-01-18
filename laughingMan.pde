
/*
project name:laughingMan
createBy:hidenori

<<概要>>
①PCの内臓カメラを起動し、人の顔を検知する。
②検知した顔のサイズに、攻殻機動隊の笑い男画像を当てる。
③笑い男のパーツは、回転部分と顔部分の２つ。
④回転部分は、右回転をさせながら表示させる。

<<ポイント>>
①笑い男の背景部分のみを回転させるため、laughFaceに対してはrotateを打ち消してから描画。
②２枚の円形画像を重ね合わせるため描画はcenterモードが楽。	

*/


//------------------------------------------------------------------
import processing.video.*; // Videoを扱うライブラリ
import gab.opencv.*;//openCVライブラリ
import java.awt.Rectangle;//顔認識時の四角形用ライブラリ

//------------------------------------------------------------------
Capture camera; // ライブカメラの映像をあつかうCapture型の変数
OpenCV opencv;
Rectangle[] faces;//顔認識結果を格納する配列変数
PImage laughFace;
PImage laughRing;
float roll;//回転速度変数

//------------------------------------------------------------------
void setup() {
	size(640, 480);
	frameRate(60);

	//カメラ起動+顔認識設定
	camera = new Capture(this, width, height,12);
  	opencv = new OpenCV(this,camera);
  	opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE); 
  	camera.start();

  	//笑い男画像の呼び出し
  	laughFace = loadImage("data/faceParts.png");
  	laughRing = loadImage("data/ringParts.png");
  	imageMode(CENTER);//円形の画像を重ね合わせるので、中心点から描画する。
  	roll = 0;
}

//------------------------------------------------------------------
void draw() {
	
	opencv.loadImage(camera);
  	image(camera, width/2, height/2);//画面中心部を原点にカメラからの画像を描画
  	faces = opencv.detect();//読み込んだcascadeを元に、顔認識
  	roll += 0.4;//回転速度を設定
  	
  	//認識した箇所に笑い男を表示する
	if(faces.length != 0){
		for (int i = 0; i < faces.length; i++) {
	    	translate(faces[i].x+faces[i].width/2,faces[i].y+faces[i].height/2);//笑い男画像は顔の中心部を原点に描画
	    	rotate(roll);
	    	image(laughRing, 0, 0, faces[i].width*1.5, faces[i].height*1.5);
	    	rotate(-roll);//face部分は回転させないので、-回転で打ち消す
	    	image(laughFace, 0, 0, faces[i].width*1.3, faces[i].height*1.3);
	    }
	}
	saveFrame("frames/####.png");//実行結果を保存する
}

//------------------------------------------------------------------
//カメラの映像が更新されるたびに、最新の映像を読み込む
void captureEvent(Capture camera) {
    camera.read();
}
