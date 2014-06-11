/*
 * By Oswaldo Linhares - oswaldolinhares@gmail.com
 *
 * Como todo bom início de aprendizagem 
 * um Hello World em JavaFX!
 *
 */

//IMPORTANDO BIBLIOTECAS
import javafx.application.Application;
import javafx.stage.Stage;
import javafx.scene.Scene;
import javafx.scene.layout.StackPane;
import javafx.scene.control.Button;

public class Ola extends Application {
    public static void main(String[] args) {
        launch(args);
    }
    @Override public void start(Stage stage){
					Button btn = new Button("Clica em Mim"); 
				StackPane raiz = new StackPane();	
				raiz.getChildren().add(btn);
				Scene scene = new Scene(raiz);
				stage.setScene(scene);
				stage.setWidth(300); stage.setHeight(300);
        stage.setTitle("Ola Mundo"); stage.show();
    }
}
