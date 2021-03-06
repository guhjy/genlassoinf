## Make sure you're working from [dropboxfolder]/code
source("settings.R")
source('funs.R')
source('testfuns.R')
source('dualPathSvd2.R')
library(genlasso)
require(RColorBrewer)
outputdir = "output"
codedir = "."

#require(plyr)
#require(grid)
#source("http://peterhaschke.com/Code/multiplot.R")
 
### Up-then-down signal Example ######

#  # Generate stuff
#  lev1  = 0 
#  sigma = 1
#  nsim = 10000
#  
#  # don't run unless necessary, find Rdata file first
#  # load(file=file.path(outputdir,"hybridsegmentmadecut-uncond.Rdata")))
#    lev2 = lev1 + 2
#    p1spike = p1segment = p21spike = p21segment = rep(NA,nsim)

#  # calculate CONDITIONAL power after one or two steps
#    numsteps = 2
#    ii = 0
#    kk = 0
#    jj = 0
#    while(kk <= nsim & jj <= nsim){
#      ii = ii + 1
#      # generate data and obtain path + polyhedron
#      y0 <- alternjump.y(lev1 = lev1, lev2 = lev2, sigma = sigma)
#      beta0 <- alternjump.y(returnbeta=T, lev1=lev1, lev2=lev2, sigma = sigma)
#      f0 <- dualpathSvd2(y0, dual1d_Dmat(length(y0)), maxsteps = numsteps,verbose=FALSE,approx=TRUE)
#      
#      if(f0$pathobj$B[1] %in% c(20,40)){
#        # form polyhedron and contrasts
#        G               <- getGammat(obj=f0,y=y0,k=1, usage = "dualpathSvd")
#        d1spike         <- getdvec(obj=f0,y=y0,k=1,type="spike",usage="dualpathSvd", matchstep=T)
#        d1segment       <- getdvec(obj=f0,y=y0,k=1,type="segment",usage="dualpathSvd", matchstep=T)
#          
#        #store things      
#        p1spike[kk]              <- pval.fl1d(y0,G,d1spike,sigma, approx=TRUE, approxtype = "rob", threshold=TRUE)
#        p1segment[kk]       <- pval.fl1d(y0,G,d1segment,sigma, approx=TRUE, approxtype = "rob", threshold=TRUE)
#        kk=kk+1
#      }

#     if(f0$pathobj$B[1:2] == c(20,40) | f0$pathobj$B[1:2] == c(40,20) ){
#        # form polyhedron and contrasts
#        G2              <- getGammat(obj=f0,y=y0,k=numsteps,usage="dualpathSvd")
#        d1spike         <- getdvec(obj=f0,y=y0,k=1,type="spike",usage="dualpathSvd",matchstep=T)
#        d1segment       <- getdvec(obj=f0,y=y0,k=1,klater=2,type="segment",usage="dualpathSvd",matchstep=F)
#     
#        #store things
#        p21spike[kk]         <- pval.fl1d(y0,G2,d1spike,  sigma, approx=TRUE, approxtype = "rob", threshold=TRUE)
#        p21segment[kk]       <- pval.fl1d(y0,G2,d1segment,sigma, approx=TRUE, approxtype = "rob", threshold=TRUE)      
#        jj=jj+1
#      }
#      cat('\r', c(ii,kk,kk-jj))
#    }
#    propcorrect.step1 = kk/ii
#    propcorrect.step2 = jj/ii
#    save(list=c("lev1","lev2","sigma","p1spike", "p21spike", "p1segment", "p21segment", "nsim", "ii","jj","kk","propcorrect.step1", "propcorrect.step2"), file=file.path(outputdir,"updown-example.Rdata"))



###########################################
#### plotting QQ plots for p-values #######
###########################################

  load(file=file.path(outputdir,"updown-example.Rdata"))
    
  ## left plot ##
  w=5
  h=5
  xlab = "Location"
  w = 5; h = 5
  pch = 16; lwd = 2
  pcol = "gray50"
  ylim = c(-6,5)
  mar = c(4.5,4.5,0.5,0.5)
  xlim = c(0,70)
  xticks = c(0,2,4,6)*10
  let = c("A","B")
  ltys.sig = 1
  lwd.sig = 2
  pch.dat = 16
  pcol.dat = "grey50"
  pch.contrast = 17
  lty.contrast = 2
  lcol.sig = 'red'
  pcol.spike=3
  pch.qq=16
  pcol.segment=4
  pcols.delta = brewer.pal(n=3,name="Set2")
  pch.segment = 17
  pch.spike = 15
  cex.contrast = 1.2

  ##################################
  ## Example of data and contrast ##
  ##################################
  pdf("output/updown-example-data-and-contrast.pdf", width=w,height=h)   
  par(mar=c(4.1,3.1,3.1,1.1))
      set.seed(0)
      sigma = 1
      y0    = alternjump.y(returnbeta=F,lev1=0,lev2=2,sigma=sigma,n=60)
      beta0 = alternjump.y(returnbeta=T,lev1=0,lev2=2,sigma=sigma,n=60)
      
      x.contrasts = c(1:60)
      v.spike = c(rep(NA,29),.5*c(-1,+1)-2, rep(NA,29))
      v.segment = c(.3*rep(-0.7,30)-2 , .3*rep(+0.7,30)-2 )
      
      v1.spike = c(rep(NA,19),.6*c(-1,+1)-2, rep(NA,39))-1
      v1.segment = c(.3*rep(-0.7,20)-2 , .3*rep(+0.7,20)-2 , rep(NA,20))-1
      
      v2.spike = c(rep(NA,19),.6*c(-1,+1)-2, rep(NA,39))-3
      v2.segment = c(.3*rep(-0.7,20)-2 , .3*rep(+0.35,40)-2)-3
            

      plot(y0, ylim = ylim,axes=F, xlim=xlim, xlab = xlab, ylab = "", pch=pch, col=pcol);
      axis(1, at = xticks, labels = xticks); axis(2)
      lines(beta0,col="red",lty=ltys.sig, lwd=lwd.sig)
      ii=2; text(x=45,y=ii, label = bquote(delta==.(ii)))
      points(v1.segment~x.contrasts, pch = pch.segment, col = 4) 
      points(v1.spike~x.contrasts, pch = pch.spike, col = 3)
      points(v2.segment~x.contrasts, pch = pch.segment, col = 4)
      points(v2.spike~x.contrasts, pch = pch.spike, col = 3)

#      abline(h = c(mean(v1.segment,na.rm=T), col = 'lightgrey')
      lines(x = c(0,61), y = rep(mean(v1.segment,na.rm=T),2), col = 'lightgrey' )
      lines(x = c(0,61), y = rep(mean(v2.segment,na.rm=T),2), col = 'lightgrey' )
      ii=1; text(x=67,y=mean(v1.segment,na.rm=T), label = bquote(Step~.(ii)))
      ii=2; text(x=67,y=mean(v2.segment,na.rm=T), label = bquote(Step~.(ii)))
      
#      legend("topleft", pch=c(pch.dat,NA,pch.contrast,pch.contrast), 
#             lty=c(NA,2,NA,NA), lwd=c(NA,2,NA,NA),
#             col = c(pcol.dat, lcol.sig, pcol.spike,pcol.segment),
#             legend=c("Data", "Signal","Spike Contrast", "Segment contrast"))

      title(main=expression("Data example"))
  graphics.off()
    
  ##########################################
  ## QQ plot of correct location p-values ##
  ##########################################

  pspikes = list(p1spike, p21spike)
  psegments = list(p1segment, p21segment)
  pvals.list = list(pspikes, psegments)

  contrast.type = c("Spike", "Segment")
  for(jj in 1:2){
    pdf(paste0("output/updown-example-qqplot-",tolower(contrast.type[jj]),".pdf"), width=5,height=5)
#      mydat = dat[[jj]]
      unif.p = runif(10000,0,1)

      for(ii in 1:2){
        pvals = pvals.list[[jj]]
        if(ii!=1) par(new=T) 
#        qqplot(y = pvals[[ii]],
#               x = unif.p,
#               axes=F, xlab="", ylab="", col = pcols.delta[ii])
        a = qqplot(y=pvals[[ii]], x=unif.p, plot.it=FALSE)
        myfun = (if(ii==1) plot else points)
        suppressWarnings(
            myfun(x=a$y, y=a$x, axes=F, xlab="", ylab="", col = pcols.delta[ii], pch=pch.qq)
        )    
        abline(0,1,col='lightgrey')
      }
      axis(2);axis(1)
      mtext("Observed",2,padj=-4)
      mtext("Expected",1,padj=4)
      title(main = bquote(.(contrast.type[jj])~test~p-values))
      if(jj==1){
        legend("bottomright", col = pcols.delta, 
               lty = 1, lwd = 5, 
               legend = sapply(c(bquote(Step~1),
                                 bquote(Step~2)), as.expression) )
      }

     graphics.off()    
   }


#########################################################
#### plotting p-value densities with ggplot (old) #######
#########################################################

#  # plot it
#    load(file=file.path(outputdir,"updown-example.Rdata"))
#    pdf("output/updown-example.pdf", width=18,height= 5)
#      cbPalette <- c("#999999", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")[c(2,3,8,4,6)] # http://www.cookbook-r.com/Graphs/Colors_%28ggplot2%29/
##      # Left
##      y0 <- alternjump.y(lev1 = lev1, lev2 = lev2)
##      beta0 <- alternjump.y(returnbeta=T, lev1=lev1, lev2=lev2)
##      plot(y0, xlab = "coordinate", ylab = "y", axes=F, main = "signal")
##      axis(1); axis(2)
##      lines(beta0, col = 'red', lwd=2)

#      # Top left: the contrasts at step 1 being tested
#      set.seed(1)
#      sigma = 1
#      y0    = alternjump.y(returnbeta=F,lev1=0,lev2=2,sigma=sigma,n=60)
#      beta0 = alternjump.y(returnbeta=T,lev1=0,lev2=2,sigma=sigma,n=60)
#      x0 = c(1:60)
#      dt = data.frame(x0, y0, beta0)
#      a1 <- ggplot(dt, aes(x=x0, y=y0, colour="x"))
#      a1 <- a1 + geom_point()
#      line.data = data.frame(x = x0, y = beta0, z = "signal")    
#      a1 <- a1 + geom_line(aes(x=x0, y = beta0, color = "signal"), size = 1.2, data = line.data) +
#                 scale_color_manual(name = "", values = c("x"="black", "signal"="red") ) + scale_linetype_manual(values = c("dashed","dashed"),  guide = guide_legend(override.aes = list(linetype = c("blank", "solid"), shape = c(1, NA))))
#      a1 <- a1 + xlab("Coordinates") + ylab("y")
#      a1 <- a1 + scale_x_continuous(limits = c(0, 70))
#      a1 <- a1 + ggtitle("Data and Underlying Signal") + 
#                 theme(plot.title = element_text(lineheight=.8, face="bold"))
##      a1 <- a1 + theme(plot.margin = unit(c(1,2,0,0), "cm"))  
#      a1 <- a1 + scale_fill_identity(guide = "legend")
#      a1 <- a1 + geom_text(aes(x=c(45),y=c(2), label = "delta==2"),parse = T,size=3,fontface = 'plain')

#      # Top Right: the contrasts at step 2 being tested                
#      set.seed(1)
#      sigma = 1
#      y0    = alternjump.y(returnbeta=F,lev1=0,lev2=2,sigma=sigma,n=60)
#      beta0 = alternjump.y(returnbeta=T,lev1=0,lev2=2,sigma=sigma,n=60)
#      x0 = 1:60
#      x0.spike = c(rep(NA,19),.3*c(-1,+1)-2, rep(NA,39))-1
#      x0.segment = c(.3*rep(-0.7,20)-2 , .3*rep(+0.7,20)-2 , rep(NA,20))-1
#      
#      x1.spike = c(rep(NA,19),.3*c(-1,+1)-2, rep(NA,39))-3
#      x1.segment = c(.3*rep(-0.7,20)-2 , .3*rep(+0.35,40)-2)-3
#            
#      labs = expression(delta==0,delta==1,delta==2)
#      x0 = c(1:60)
#      dt = data.frame(y0, beta0, x0, x0.spike, x0.segment)
#      a2 <- ggplot(dt, aes(x=x0, y=y0))
#      a2 <- a2 + geom_point()
#      line.data = data.frame(x = x0, y = beta0, z = "signal")    
#      seg.data = data.frame(x = x0, y = x0.segment, z = "segment contrast")
#      spike.data = data.frame(x = x0, y = x0.spike, z = "spike contrast")
#      a2 <- a2 + geom_line(aes(x=x0, y = beta0, color = "signal"), size=1.2, data = spike.data) + 
#                 geom_point(aes(x=x0, y = x0.segment, color = "segment contrast"), size=3, data = seg.data) +
#                 geom_point(aes(x=x0, y = x0.spike, color = "spike contrast"), size=3, data = spike.data)           
#                 
#      a2 <- a2 + geom_point(aes(x=x0, y = x1.segment, color = "segment contrast"), size=3, data = seg.data) +
#                 geom_point(aes(x=x0, y = x1.spike, color = "spike contrast"), size=3, data = spike.data)           
#                 
#      a2 <- a2 + scale_y_continuous(breaks=c(0:5),labels=c(0:5))                 
#      a2 <- a2 + scale_x_continuous(limits = c(0, 70))
#      a2 <- a2 + xlab("Coordinates") + ylab("y")
#      a2 <- a2 + annotate("text",x=c(45),y=c(2), label = "delta==2",parse = T,size=3, fontface = 'plain')

#      a2 <- a2 + annotate("text",x=c(65),y=c(-3), label = "Step 2", parse = F,size=3, fontface = 'plain')
#      a2 <- a2 + annotate("text",x=c(65),y=c(-5), label = "Step 1", parse = F,size=3, fontface = 'plain')

#      a2 <- a2 + scale_colour_manual(name = "",
#                                     values=c("signal"="red","x" ="black", "segment contrast"="green", "spike contrast" = "blue"))
#                                     
##      a2 <- a2 + scale_linetype_manual(breaks = c("solid","blank", "blank"),  guide = guide_legend(override.aes = list(linetype = c("solid", "blank","blank"), shape = c(1, NA,NA))))
#      

#      a2 <- a2 + theme(legend.position = c(0.85, 0.85), legend.background = element_rect(fill = "grey90", size = 1))
#      a2 <- a2 + theme(plot.margin = unit(c(1,2,0,0), "cm"))  
#      ## todo: make some legends
#      a2 <- a2 + ggtitle("Contrasts used by \n Spike and Segment Test")  + 
#                 theme(plot.title = element_text(lineheight=.8, face="bold"))  
#               
#      # bottom left
#      my.data <- as.data.frame(rbind(cbind(p1spike,1),
#                                     cbind(p21spike,2)))
#      names(my.data) = c("V1","V2")
#      colors <- cbPalette[1:2]
#      labs <- expression(step~1, step~2)
#      
#      my.data$V2=as.factor(my.data$V2)
#        
#      res <- dlply(my.data, .(V2), function(x) density(x$V1))
#      dd <- ldply(res, function(z){
#                          data.frame(Values = z[["x"]], 
#                                     V1_density = z[["y"]])
#      })
#      
#      poffset.x = .2 # adapt 0.1 as needed
#      dd$Values = dd$Values + rep(c(0,1)*poffset.x,each=512)
#      dd$offest=-(as.numeric(dd$V2)-1)*.2# adapt the 1 value as you need
#      dd$V1_density_offest = dd$V1_density+dd$offest
#        

#      a3 <- ggplot(dd) 
#      a3 <- a3 + geom_line( aes(Values, V1_density_offest, color=V2), size = 1.5)
#      a3 <- a3 + geom_ribbon(aes(Values, ymin=offest,ymax=V1_density_offest, fill=V2),alpha=0.3)
#      a3 <- a3 + scale_color_manual(values=colors,guide=FALSE)
#      a3 <- a3 + scale_x_continuous(breaks=NULL) 
#      a3 <- a3 + scale_y_continuous(breaks=c(0:5),labels=c(0:5))
#      a3 <- a3 + xlab("p-values") + ylab("Fitted Density")
#      a3 <- a3 + scale_fill_manual(name="Conditioning Steps",
#                                 values=colors,
#                                 labels=labs)
#      a3 <- a3 + ggtitle("Spike Test p-value Distribution \n Correct Location") + 
#               theme(plot.title = element_text(lineheight=.8, face="bold"))
#      a3 <- a3 + theme(legend.position = c(0.85, 0.85), legend.background = element_rect(fill = "grey90", size = 1))

#      # bottom right
#      my.data <- as.data.frame(rbind(cbind(p1segment,1),
#                                     cbind(p21segment,2)))
#      names(my.data) = c("V1","V2")
#      colors <- cbPalette[1:2]
#      labs <- expression(step~1, step~2)
#      
#      my.data$V2=as.factor(my.data$V2)
#        
#      res <- dlply(my.data, .(V2), function(x) density(x$V1))
#      dd <- ldply(res, function(z){
#                          data.frame(Values = z[["x"]], 
#                                     V1_density = z[["y"]])
#      })
#      
#      poffset.x = .2 # adapt 0.1 as needed
#      dd$Values = dd$Values + rep(c(0,1)*poffset.x,each=512)
#      dd$offest=-(as.numeric(dd$V2)-1)*1# adapt the 1 value as you need
#      dd$V1_density_offest = dd$V1_density+dd$offest
#        

#      a4 <- ggplot(dd) 
#      a4 <- a4 + geom_line( aes(Values, V1_density_offest, color=V2), size = 1.5)
#      a4 <- a4 + geom_ribbon(aes(Values, ymin=offest,ymax=V1_density_offest, fill=V2),alpha=0.3)
#      a4 <- a4 + scale_color_manual(values=colors,guide=FALSE)
#      a4 <- a4 + scale_x_continuous(breaks=NULL) 
#      a4 <- a4 + scale_y_continuous(breaks=c(0:10),labels=c(0:10))
#      a4 <- a4 + xlab("p-values") + ylab("Fitted Density")
#      a4 <- a4 + scale_fill_manual(name="Conditioning Steps",
#                                 values=colors,
#                                 labels=labs)
#      a4 <- a4 + ggtitle("Spike Test p-value Distribution \n Correct Location") + 
#               theme(plot.title = element_text(lineheight=.8, face="bold"))
#      a4 <- a4 + theme(legend.position = c(0.85, 0.85), legend.background = element_rect(fill = "grey90", size = 1))

#      multiplot(a2, a3, a4, layout = matrix(c(1,2,3),nrow=1,byrow=T), cols=3) 
#      
#    dev.off()

  
### Seeing how frequently FL catches the correct jump location in the alternating-jump example ###
lev0 = 1
lev2 = 2
sigma = 1
nsim=10000
locs = matrix(NA,nrow=nsim,ncol=2)
for(isim in 1:nsim){
  cat(isim, " ")
  y0    <- alternjump.y(lev1 = lev1, lev2 = lev2, sigma = sigma)
  f0    <- trendfilter(y0,ord=0,maxsteps=2)
  locs[isim,] = f0$pathobj$B
}
sum(locs[,1]==20 | locs[,1]==40)/nsim
sum(locs[,2]==20 | locs[,2]==40)/nsim
sum(locs[,1]==20 & locs[,2]==40)/nsim + sum(locs[,2]==20 & locs[,1]==40)/nsim
sum(locs[,1]!=20 & locs[,2]==40)/nsim + sum(locs[,1]==20 & locs[,2]!=40)/nsim
#     


#  # Generate stuff
#  lev1  = 0 
#  sigma = 1
#  nsim = 10000
#  
#  # don't run unless necessary, find Rdata file first
#  # load(file=file.path(outputdir,"hybridsegmentmadecut-uncond.Rdata")))
#    lev2 = lev1 + 2
#    p1spike = p1segment = p21spike = p21segment = rep(NA,nsim)

#  # calculate CONDITIONAL power after one or two steps
#    numsteps = 2
#    ii = 0
#    kk = 0
#    jj = 0
#    while(kk <= nsim & jj <= nsim){
#      ii = ii + 1
#      # generate data and obtain path + polyhedron
#      y0 <- alternjump.y(lev1 = lev1, lev2 = lev2, sigma = sigma)
#      beta0 <- alternjump.y(returnbeta=T, lev1=lev1, lev2=lev2, sigma = sigma)
#      f0 <- dualpathSvd2(y0, dual1d_Dmat(length(y0)), maxsteps = numsteps,verbose=FALSE,approx=TRUE)
#      
#      if(f0$pathobj$B[1] %in% c(20,40)){
#        # form polyhedron and contrasts
#        G               <- getGammat(obj=f0,y=y0,k=1, usage = "dualpathSvd")
#        d1spike         <- getdvec(obj=f0,y=y0,k=1,type="spike",usage="dualpathSvd", matchstep=T)
#        d1segment       <- getdvec(obj=f0,y=y0,k=1,type="segment",usage="dualpathSvd", matchstep=T)
#          
#        #store things      
#        p1spike[kk]              <- pval.fl1d(y0,G,d1spike,sigma, approx=TRUE, approxtype = "rob", threshold=TRUE)
#        p1segment[kk]       <- pval.fl1d(y0,G,d1segment,sigma, approx=TRUE, approxtype = "rob", threshold=TRUE)
#        kk=kk+1
#      }

#     if(f0$pathobj$B[1:2] == c(20,40) | f0$pathobj$B[1:2] == c(40,20) ){
#        # form polyhedron and contrasts
#        G2              <- getGammat(obj=f0,y=y0,k=numsteps,usage="dualpathSvd")
#        d1spike         <- getdvec(obj=f0,y=y0,k=1,type="spike",usage="dualpathSvd",matchstep=T)
#        d1segment       <- getdvec(obj=f0,y=y0,k=1,klater=2,type="segment",usage="dualpathSvd",matchstep=F)
#     
#        #store things
#        p21spike[kk]         <- pval.fl1d(y0,G2,d1spike,  sigma, approx=TRUE, approxtype = "rob", threshold=TRUE)
#        p21segment[kk]       <- pval.fl1d(y0,G2,d1segment,sigma, approx=TRUE, approxtype = "rob", threshold=TRUE)      
#        jj=jj+1
#      }
#      cat('\r', c(ii,kk,kk-jj))
#    }
#    propcorrect.step1 = kk/ii
#    propcorrect.step2 = jj/ii
#    save(list=c("lev1","lev2","sigma","p1spike", "p21spike", "p1segment", "p21segment", "nsim", "ii","jj","kk","propcorrect.step1", "propcorrect.step2"), file=file.path(outputdir,"updown-example.Rdata"))
