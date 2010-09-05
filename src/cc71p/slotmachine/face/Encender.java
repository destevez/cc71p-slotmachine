package cc71p.slotmachine.face;

import cc71p.slotmachine.SlotMachine;
/**
 * Clase inicializadora (ejecutable) de la Slot Machine. Enciende la SM
 * 
 * @author daniel
 *
 */
public class Encender {
	public static void main(String[] args) {
		SlotMachine sM = new SlotMachine();
		InputBox inputBox = new InputBox();
		System.out.println("Bienvenido a SlotMachine v0.1");
		while(true){
			System.out.print("Ingrese la acción que desea realizar:\n" +
					"0:Salir\n1:Ingresar creditos\n2:Retirar dinero\n3:Oprimir boton play\n4:Oprimir boton lock\n");
			try{
				int o = Integer.parseInt(inputBox.getLine());
				switch (o) {
				case 0:
					System.exit(0);
					break;
				case 1:
					try{
						System.out.println("Ingrese cantidad de creditos a insertar en la máquina");
						int c = Integer.parseInt(inputBox.getLine());
						sM.iH.insert(c);
					}catch (Exception e) {
						System.out.println("Ingrese una cantidad válida por favor.");
					}
					break;
				case 2:
					sM.iH.get();
					break;
				case 3:
					sM.iU.play();
					break;
				case 4:
					System.out.println("Ingrese el boton de bloqueo a presionar. [1-5]");
					try{
						int b = Integer.parseInt(inputBox.getLine());
						sM.iU.lock(b-1);
					}catch (Exception e) {
						System.out.println("Ingrese una cantidad válida por favor.");
					}
					break;
				default:
					break;
				}
			}catch (Exception e) {
				System.out.println("Ingrese una opción válida por favor.");
			}
			
		}
	}
}
