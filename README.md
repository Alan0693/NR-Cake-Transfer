# **Cake Image Datasets**

We offer data sets for 4 kinds of cakes, including coconut, chocolate, matcha, redvelvet. The Google Drive link is: [**Cake image dataset**.](https://drive.google.com/drive/folders/1jeQPmwSnKPxxnH8h0n97phub5S7XDQy4?usp=sharing)

In this shared folder, `train` represents the training dataset, where the four compressed packages `coconut.zip`, `chocolate.zip`, `matcha.zip`, `redvelvet.zip` represent the clean training cake image set, `coconut_mix0.09.zip`, `chocolate_mix0.09.zip`, `matcha_mix0.09.zip`, `redvelvet_mix0.09.zip` represent four mixed noise training sets with Gaussian noise with variance equal to **0.09**.

In addition, `test` stands for the test dataset, and we give a test dataset that includes **seven** additional test noises *(Gaussian, Salt&Pepper, Uniform, Color, Laplacian, Speckle, Shot(Poisson))* for the clean test dataset. Note that: In the shared test dataset, only `chocolate` cake was subjected to noise processing, since in order to improve the test efficiency, we mainly tested the transformation of cake images in three directions: `chocolate2coconut`, `chocolate2matcha` and `chocolate2redvelvet`. So in order to keep the reference images (coconut, matcha, redvelvet) clean during the test, we only treated the chocolate cake images with noise.

