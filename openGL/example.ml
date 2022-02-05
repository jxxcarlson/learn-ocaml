open GL
open Glut

let display () =
  glClear [GL_COLOR_BUFFER_BIT];
  glRotate ~angle:(Sys.time() *. 0.2) ~x:0.0 ~y:0.0 ~z:1.0;
  glBegin GL_TRIANGLES;
  glColor3 ~r:1.0 ~g:0.0 ~b:0.0;  glVertex2 (-1.0) (-1.0);
  glColor3 ~r:0.0 ~g:1.0 ~b:0.0;  glVertex2 ( 0.0) ( 1.0);
  glColor3 ~r:0.0 ~g:0.0 ~b:1.0;  glVertex2 ( 1.0) (-1.0);
  glEnd ();
  glutSwapBuffers ();
;;

let () =
  ignore(glutInit Sys.argv);
  glutInitDisplayMode [GLUT_DOUBLE];
  ignore(glutCreateWindow ~title:"simple demo");
  glutDisplayFunc ~display;
  glutIdleFunc ~idle:(glutPostRedisplay);
  glutMainLoop ();
;;

