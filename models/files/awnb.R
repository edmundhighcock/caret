modelInfo <- list(label = "Naive Bayes Classifier with Attribute Weighting",
                  library = "bnclassify",
                  type = "Classification",
                  parameters = data.frame(parameter = c("smooth"),
                                          class = c("numeric"),
                                          label = c("Smoothing Parameter")),
                  grid = function(x, y, len = NULL, search = "grid") {
                    if(search == "grid") { 
                      out <- data.frame(smooth = 0:(len-1))
                    } else {
                      out <- data.frame(smooth= runif(len, min = 0, max = 10))
                    }
                    out
                  },
                  loop = NULL,
                  fit = function(x, y, wts, param, lev, last, classProbs, ...) {
                    dat <- if(is.data.frame(x)) x else as.data.frame(x)
                    dat$.outcome <- y
                    struct <- bnclassify::nb(class = '.outcome', dataset = dat)
                    args <- list(
                      x = bnclassify::nb(
                        '.outcome',
                        dataset = dat
                      ),
                      dataset = dat,
                      smooth = param$smooth
                    )
                    dots <- list(...)
                    args <- c(args, dots)
                    do.call(bnclassify::lp, args)
                  },
                  predict = function(modelFit, newdata, submodels = NULL) {
                    if(!is.data.frame(newdata)) newdata <- as.data.frame(newdata)
                    predict(modelFit, newdata)       
                  },
                  prob = function(modelFit, newdata, submodels = NULL) {
                    if(!is.data.frame(newdata)) newdata <- as.data.frame(newdata)
                    predict(modelFit, newdata, prob = TRUE) 
                  },
                  levels = function(x) x$obsLevels,
                  predictors = function(x, s = NULL, ...) x$xNames,
                  tags = c("Bayesian Model", "Categorical Predictors Only"),
                  sort = function(x) x[order(x[,1]),])
