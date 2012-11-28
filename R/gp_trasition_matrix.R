  
#' Determine the transition matrix given a Guassian process
#' 
#' @param gp a gpfit type object, a list with the GP mean gp$Ef, Covariance gp$Cf on grid gp$X
#' @param h_grid the harvest grid over which to compute.  Assumed to match the stock grid gp$X if not given.
#' @return a list of matrices corresponding to the state transition matrix at each harvest level h
#' @export
gp_transition_matrix <- function(gp, h_grid=NULL){
  # consider taking x_grid, Ef, & Cf as arguments instead?
  x_grid <- gp$X
  if(is.null(h_grid))
    h_grid <- x_grid
  V <- sqrt(diag(gp$Cf))
  matrices_gp <- lapply(h_grid, function(h){
    F_ <- sapply(x_grid, function(x) dnorm(x, gp$Ef-h, V))
    F_ <- rownorm(F_)
  })
  matrices_gp
}

#' calculate transition matrix based on parameterized function
#' 
#' @param f the transtion function, a function of state x, harvest h, and parameters p
#' @param p the parameters p of the transition function
#' @param x_grid the grid over which to solve 
#' @param h_grid the harvest grid over which to compute.  Assumed to match the stock grid gp$X if not given.
#' @return a list of matrices corresponding to the state transition matrix at each harvest level h
#' @export
f_transition_matrix <- function(f, p, x_grid, h_grid=NULL){
  if(is.null(h_grid))
    h_grid <- x_grid
  matrices_F <- lapply(h_grid, function(h){
    mu <- sapply(x_grid, f, h, p)
    F_true <- sapply(x_grid, function(x) dnorm(x, mu, sigma_g))
    F_true <- rownorm(F_true)
  })
  matrices_F
}


# internal helper function
rownorm <- function(M) t(apply(M, 1, function(x) x/sum(x)))