import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from scipy.interpolate import Rbf
# make colormaps
from matplotlib import cm
from matplotlib.colors import ListedColormap
# used for clip out the Hex edges
from matplotlib.patches import RegularPolygon
import matplotlib.patches as patches

class Nex:

    # class variables
    top = cm.get_cmap('YlGnBu_r', 128)
    #top = cm.get_cmap('Blues_r', 128)
    #bottom = cm.get_cmap('Reds', 128)
    bottom = cm.get_cmap('YlOrRd', 128)
    newcolors = np.vstack((top(np.linspace(0, 1, 128)),
                           bottom(np.linspace(0, 1, 128))))
    newcmp = ListedColormap(newcolors, name='BlueReds')
    # rbf color box
    rbf_func=['multiquadric', 'inverse', 'gaussian', 'linear', 'cubic', 'quintic', 'thin_plate']

    trynewcolor=['jet', 'magma', 'plasma', 'inferno', 'viridis']
    #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


    # Load the data.
    def __init__(self, filename):
        #df_points = pd.read_table("temp.dat", 
        self.fname = filename
        self.df_points = pd.read_table(self.fname+'.dat', 
                         sep="\s+", 
                         usecols=[0,1,3], header=None)
        self.df_points.columns=['vx', 'vy', 'Nex']

        # Build a regular grid with G_size-metre cells.
        G_size = 300j
        self.extent = x_min, x_max, y_min, y_max = [self.df_points.vx.min(), self.df_points.vx.max(),
                                               self.df_points.vy.min(), self.df_points.vy.max()]

        grid_x, grid_y = np.mgrid[x_min:x_max:G_size, y_min:y_max:G_size]

        # Make the interpolator and do the interpolation.
        rbfi = Rbf(self.df_points.vx, self.df_points.vy, self.df_points.Nex, function=self.rbf_func[1])#, smooth=1, epsilon=1) #, multiquadric, gaussian, linear, )
        self.di = rbfi(grid_x, grid_y)



    # Make the plot.
    def plot_nex(self, radius):
        
        #fig=plt.figure(figsize=(8, 7))#, facecolor='black')
        fig, ax =plt.subplots(figsize=(8, 7))
        im1 = plt.imshow(self.di.T, origin="lower", cmap=self.trynewcolor[2], extent=self.extent )
        #plt.imshow(di.T, origin="lower", extent=[-1,1,-1,1], cmap=trynewcolor[2])
        im2 = plt.scatter(self.df_points.vx, self.df_points.vy, cmap=self.trynewcolor[2], c=self.df_points.Nex, alpha=0.1, clip_on=True, zorder=100, s=30)#cmap='bwr', edgecolor='#ffffff66',s=30)

        # Define Hex area.
        poly = RegularPolygon([ 0.0,  0.0 ], 6, radius, orientation=np.pi/2.0, transform=ax.transData)#0.917878)#, fc='none', ec='k', transform=ax.transAxes)
        im1.set_clip_path(poly)
        im2.set_clip_path(poly)
        #####

        # set the color bar range.
        #plt.clim(0, 0.05)
        plt.colorbar(im2, shrink=0.8)
        #plt.savefig('Interpolat_imshow.png')#,facecolor=fig.get_facecolor(), transparent=True)
        plt.savefig(self.fname+'.png')
       # plt.show()
if __name__ == "__main__":
    print ("run plot")
    with open("filelist.txt", "r") as name_file:
        for line in name_file:
            fn = line.strip()
            plot = Nex(fn)
            plot.plot_nex(0.91)
   # plot=Nex("Saw00001001EX")
   # plot.plot_nex(0.91)
