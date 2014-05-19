library("car")

eharm <- read.csv("C:/Users/mcast_000/Documents/datafest/eharmony.csv")
eharm_med <- read.csv("C:/Users/mcast_000/Documents/datafest/eharmony_medium.csv")
eharm_small <- read.csv("C:/Users/mcast_000/Documents/datafest/eharmony_small.csv")

eharm$u_ss_ethnicityid <- recode(eharm$u_ss_ethnicityid,"5:6 = 7")
eharm$c_ss_ethnicityid <- recode(eharm$c_ss_ethnicityid,"5:6 = 7")

attach(eharm)
fem_r <- table(u_ss_ethnicityid,c_ss_ethnicityid,m_comm_7d_u,m_comm_7d_c) #female x male female sen 
male_r <- table(c_ss_ethnicityid,u_ss_ethnicityid,m_comm_7d_c,m_comm_7d_u) #male x female male sen
fem_r <- fem_r[2:10,,,]
male_r <- male_r[,2:10,,]

fem_r_0 <- fem_r[,,2,1]
fem_r_1 <- fem_r[,,2,2]
male_r_0 <- male_r[,,2,1]
male_r_1 <- male_r[,,2,2]
fem_r_o <- sum(fem_r_1)/(sum(fem_r_1)+sum(fem_r_0))
male_r_o <- sum(male_r_1)/(sum(male_r_1)+sum(male_r_0))
w <- matrix(NA,4,12)
for (i in 1:11)
{
	w[1,i] <- sum(fem_r_1[i,])/(sum(fem_r_1[i,])+sum(fem_r_0[i,]))
	w[2,i] <- sum(male_r_1[i,])/(sum(male_r_1[i,])+sum(male_r_0[i,]))
	w[3,i] <- sum(fem_r_1[,i])/(sum(fem_r_1[,i])+sum(fem_r_0[,i]))
	w[4,i] <- sum(male_r_1[,i])/(sum(male_r_1[,i])+sum(male_r_0[,i]))
}

fem_p <- fem_r_1/(fem_r_0+fem_r_1)
male_p <- male_r_1/(male_r_0+male_r_1)
fem_p <- cbind(fem_p,w[1,])
male_p <- cbind(male_p,w[2,])
fem_p <- rbind(fem_p,w[3,])
male_p <- rbind(male_p,w[4,])
fem_p[10,10] <- fem_r_o
male_p[10,10] <- male_r_o

row.names(fem_p) <- c("White","Hispanic/Latin","Black","Pacific Islander",
 "Asian", "Indian","Middle Eastern","Native American","Other","Total")
colnames(fem_p) <- c("White","Hispanic/Latin","Black","Pacific Islander",
 "Asian", "Indian","Middle Eastern","Native American","Other","Total")
row.names(male_p) <- c("White","Hispanic/Latin","Black","Pacific Islander",
 "Asian", "Indian","Middle Eastern","Native American","Other","Total")
colnames(male_p) <- c("White","Hispanic/Latin","Black","Pacific Islander",
 "Asian", "Indian","Middle Eastern","Native American","Other","Total")
round(fem_p,2)
round(male_p,2)
detach(eharm)

library("plotrix")
color2D.matplot(male_p,c(0,.1),c(.2,.56),c(.2,1),xlab="Female",ylab="Male",
main = "Response Rate Male Sender eHarmony")
color2D.matplot(male_p,c(0,.1),c(.2,.56),c(.2,1),xlab="Male",ylab="Female",
main = "Response Rate Female Sender eHarmony")