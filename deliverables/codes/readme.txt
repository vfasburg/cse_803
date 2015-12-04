CSE 803: Meal Recognition Project
Team Members: Vince Fasburg, Bonnie Reiff, Josh Thomas
README.txt File for Project Code

Training:

To train the meal recognition system, open MATLAB and ensure that the folder containing 
all of the .m files is in the MATLAB path. All training images must be in the same folder.
The file names of all training images must end in ".jpg" and contain exactly one of the 
following class names:
applered
applegreen
appleyellow
banana
burger
fries << Note, this is not "frenchfry"
pizza
pasta
hotdog
strawberry
tomato 	
egg 
eggshell	
salad 	
cookie 	
rice 	
broccoli 

If you wish to use parallelism to increase the speed of training, run the command:
"matlabpool x" where x is the number of cores available on your machine

To train on the dataset, run the following command(without quotes):
"classStats = train('<<full_path_to_training_images>>');

Testing:

To test the meal reconginition system, you must place all testing images in the same
folder. There is no requirement for file names other than that they must end in ".jpg"
There must be a file named "label.txt" inside this folder with a listing of filenames
and their correct classes formatted as follows:

image1.jpg strawberry apple
image2.jpg broccoli
etc...

The classes to be used for testing are the following, note that these are not all the
same as the training classes (some conversion is done in the code).
apple
banana
burger
frenchfry
pizza
pasta
hotdog
strawberry
tomato 	
egg 	
salad 	
cookie 	
rice 	
broccoli 

To test the system, run the following command:
"performance = test(classStats, '<<path_to_testing_data_set>>');"