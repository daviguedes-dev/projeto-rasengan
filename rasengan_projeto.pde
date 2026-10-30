/**
 * Rasengan 3D  baseado no exemplo "Rotating Arcs in 3D" (
 * Alterações: arcos viraram anéis e fluxos de energia, partículas orbitando,
 * núcleo com brilho e mudança de cor (azul → laranja) ao segurar o mouse.
 */
 
final int COUNT = 120;

float[] angle = new float[COUNT];
float[] radius = new float[COUNT];
float[] speed = new float[COUNT];
float[] sizeParticle = new float[COUNT];
float[] heightParticle = new float[COUNT];

float charge = 0;

void setup() {
  size(1024, 768, P3D);
  smooth(8);
  randomSeed(100);
  hint(DISABLE_DEPTH_TEST);
  blendMode(ADD);

  for (int i = 0; i < COUNT; i++) {
    angle[i] = random(TWO_PI);
    radius[i] = random(45, 145);
    speed[i] = random(0.015, 0.065);
    sizeParticle[i] = random(2, 7);
    heightParticle[i] = random(-100, 100);
  }
}

void draw() {
  background(3, 8, 25);

  charge = lerp(charge, mousePressed ? 1 : 0, 0.04);

  translate(width/2, height/2, 0);
  scale(1 + charge);

  rotateY(frameCount * 0.008);
  rotateX(sin(frameCount * 0.01) * 0.15);

  drawGlow();
  drawEnergyRings();
  drawParticles();
  drawEnergyStreams();
  drawWhiteStreaks();
  drawCore();
}

void drawGlow() {
  noStroke();

  for (int i = 12; i >= 1; i--) {
    float r = 150 + i * 7;
    float alpha = map(i, 1, 12, 12, 1);

    fill(tone(color(0, 130, 255, alpha), color(200, 80, 45, alpha)));
    sphereDetail(32);

    pushMatrix();
    scale(r / 150.0);
    sphere(75);
    popMatrix();
  }
}

void drawEnergyRings() {
  noFill();

  for (int i = 0; i < 8; i++) {
    pushMatrix();

    rotateX(i * 0.55 + frameCount * 0.012);
    rotateY(i * 0.8 - frameCount * 0.009);
    rotateZ(i * 0.4);

    if (i % 3 == 0) {
      stroke(tone(color(220, 250, 255, 220), color(255, 190, 120, 220)));
      strokeWeight(1.8);
    } else {
      stroke(tone(color(30, 170, 255, 150), color(255, 135, 70, 170)));
      strokeWeight(2);
    }

    ellipse(0, 0, 190 + i * 9, 190 + i * 9);

    popMatrix();
  }
}

void drawParticles() {
  noStroke();

  for (int i = 0; i < COUNT; i++) {
    angle[i] += speed[i];

    float x = cos(angle[i]) * radius[i];
    float y = sin(angle[i]) * radius[i];
    float z = heightParticle[i] * sin(angle[i] * 2);

    pushMatrix();
    translate(x, y, z);

    float pulse = 1 + sin(frameCount * 0.1 + i) * 0.3;

    if (i % 7 == 0) {
      fill(tone(color(240, 255, 255, 240), color(255, 105, 30, 240)));
    } else {
      fill(tone(color(30, 180, 255, 220), color(220, 70, 25, 220)));
    }

    sphereDetail(5);
    sphere(sizeParticle[i] * pulse);

    popMatrix();
  }
}

void drawEnergyStreams() {
  for (int j = 0; j < 18; j++) {
    pushMatrix();

    rotateX(j * 0.35 + frameCount * 0.025);
    rotateY(j * 0.8 + frameCount * 0.018);

    noFill();

    if (j % 4 == 0) {
      stroke(tone(color(230, 250, 255, 230), color(255, 190, 125, 230)));
      strokeWeight(2.2);
    } else {
      stroke(tone(color(40, 190, 255, 150), color(255, 135, 70, 170)));
      strokeWeight(2);
    }

    beginShape();

    for (int i = 0; i < 360; i += 3) {
      float a = radians(i);
      float r = 95 + sin(a * 5 + frameCount * 0.08 + j) * 22;

      float x = cos(a) * r;
      float y = sin(a) * r;

      vertex(x, y, sin(a * 3 + frameCount * 0.05) * 35);
    }

    endShape();
    popMatrix();
  }
}

void drawWhiteStreaks() {
  for (int j = 0; j < 14; j++) {
    pushMatrix();

    rotateX(j * 0.47 + frameCount * 0.018);
    rotateY(j * 0.71 - frameCount * 0.023);
    rotateZ(j * 0.29);

    noFill();

    stroke(tone(color(190, 240, 255, 210), color(255, 165, 100, 210)));
    strokeWeight(1.5);

    beginShape();

    float start = frameCount * 2 + j * 35;

    for (int i = 0; i < 35; i++) {
      float a = radians(start + i * 2.5);
      float r = 105 + sin(i * 0.3 + frameCount * 0.04) * 12;

      vertex(
        cos(a) * r,
        sin(a) * r,
        sin(a * 2 + frameCount * 0.04) * 25
      );
    }

    endShape();

    popMatrix();
  }
}

void drawCore() {
  noStroke();

  fill(tone(color(0, 100, 255, 70), color(120, 45, 25, 50)));
  sphereDetail(32);
  sphere(95);

  fill(tone(color(20, 150, 255, 110), color(150, 55, 30, 70)));
  sphere(72);

  fill(tone(color(90, 205, 255, 210), color(200, 80, 40, 90)));
  sphere(48);

  fill(tone(color(210, 245, 255), color(255, 130, 70, 110)));
  sphere(25);

  fill(tone(color(255), color(255, 190, 140, 130)));
  sphere(12);
}

color tone(color blue, color orange) {
  return lerpColor(blue, orange, min(charge * 2, 1));
}
