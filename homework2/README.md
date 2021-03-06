Homework 2: Interactivity
==============================

| **Name**  | Katherine Zhao  |
|----------:|:-------------|
| **Email** | mzhao12@dons.usfca.edu |

## Instructions ##

The following packages must be installed prior to running this code:

- `ggplot2`
- `shiny`

To run this code, please enter the following commands in R:

```
library(shiny)
shiny::runGitHub('msan622', 'katherinez22', subdir = 'homework2')
```

This will start the `shiny` app. See below for details on how to interact with the visualization.


## Discussion ##

### * Visualization
An interactive scatterplot of the `movies` dataset is created using the `ggplot2` and `shiny` packages. The basic scatterplot has `budget` on the x-axis, the IMDB `rating` on the y-axis, and dots colored by the `mpaa` rating.

By adding `MPAA Rating` radio buttons, a `Movie Genres` checkbox group, a `Color Scheme` drop-down box, a `Dot Size` slider input and a 'Dot Alpha' slider input, the screenshot of the visualization is as following:

![IMAGE](shinyapp_customized.png)

To interact with the visualization, please follow the steps.

* Step 1: Selecting one `MPAA Rating`. The default value is `All`, which shows the scatter plot for movies with all ratings.

* Step 2: Checking one or multiple `Movie Genres` boxs. The default value is not checking any box, which shows the scatter plot for movies with all genres.

* Step 3: Choosing one `Color Scheme` from the drop-down list to visualize the plot with different color palettes. The default value is `Default`, which shows the scatter plot using the default color palette in `ggplot2`.

* Step 4: Choosing a `Dot Size` value by moving the slider bar. The default value is 3, which shows the dots with size equal to 3.

* Step 5: Choosing a `Dot Alpha` value by moving the slider bar. The default value is 0.5, which shows the dots with 50% transparency.

### * Customization
A few customizations were added for this visualization:

* First, modifying the panel in the `theme()` function. Removed the minor panel grid on both x-axis and y-axis using `panel.grid.minor`. Changed the major panel grid to dot-line with grey color using `panel.grid.major = element_line(color = "grey90", linetype = 3)`. Removed the background color using `panel.background`. Also, removed the panel border using `panel.border`.

* Second, modifying the axises in the `theme()` function. Increased the sizes of axises texts and labels to 1.2 times using `axis.text = element_text(size = rel(1.2))` and `axis.title = element_text(size = rel(1.2))`, respectively. This makes the texts and labels of axises easier to read.

* Third, modifying the legend in the `theme()` function. Removed background of legend and background underneath legend keys using `legend.background` and `legend.key`, respectively. Changed the font of legend text and label to italic using `legend.text` and `legend.title`, respectively. Layout of items in legends vertically using `legend.direction`. Also, adjusted the position of legend to the lower right corner of the plot using `legend.justification` and `legend.position`. 

* Fourth, used to `limits` parameter inside `scale_colour_discrete()` function to keep colors consistent in the plot when filtering out data. When changing the color palette, `limits` parameter can also be used inside `scale_color_brewer()` function to keep colors consistent of filtered data within the selected palette.

* Fifth, created a tab panel to output basic statistics of the data, including the number of movies, minimum budget and maximum budget with different `MPAA Raint` and `Movie Genres` combinations. By choosing multiple values in `Movie Genres`, the table could output the count and budget information for each genre.

* Sixth, added a download link to allow users downloading the source code from a GitHub page. 

